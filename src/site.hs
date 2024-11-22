--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Hakyll
import           Text.Pandoc.Extensions
import           Text.Pandoc.Highlighting (Style, haddock, styleToCss)
import Text.Pandoc.Options
    ( HTMLMathMethod(MathJax),
      ReaderOptions(readerExtensions),
      WriterOptions(writerHighlightStyle, writerHTMLMathMethod) )
import Text.Pandoc.Definition
    ( Block(CodeBlock, Para), Inline(Image) )
import Text.Pandoc.Walk (walkM)
import qualified Network.URI.Encode as URI (encode)
import qualified Data.ByteString.Lazy.Char8 as LBS
import qualified Data.Text as Text
import Hakyll.Process
    ( execCompilerWith,
      execName,
      newExtension,
      CompilerOut(COutFile),
      ExecutableArg(ProcArg),
      OutFilePath(SpecificPath) )
import System.IO.Temp ( writeTempFile )
import Utils
import Feeds
import Control.Monad.State
import SvgWorks
import Control.Monad (unless)
import System.Directory (doesFileExist)

--------------------------------------------------------------------------------
main :: IO ()
main = hakyllWith config $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    create ["css/syntax.css"] $ do
        route idRoute
        compile $ do
            makeItem $ styleToCss pandocCodeStyle

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.rst", "contact.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompilerWith (defaultHakyllReaderOptions { readerExtensions = extensionsFromList [Ext_emoji] } ) (defaultHakyllWriterOptions { writerHTMLMathMethod = MathJax "" } )
            >>= loadAndApplyTemplate "templates/default.html" (defaultContext <> mathCtx)
            >>= relativizeUrls

    tags <- buildTags "posts/*" (fromCapture "tags/*.html")

    tagsRules tags $ \tag pattern_ -> do
        let title = "Posts tagged \"" ++ tag ++ "\""
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll pattern_
            let ctx = constField "title" title
                      `mappend` listField "posts" (postCtxWithTags tags) (return posts)
                      `mappend` defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/tag.html" ctx
                >>= loadAndApplyTemplate "templates/default.html" (ctx <> mathCtx)
                >>= relativizeUrls

    match "posts/*" $ do
        route $ setExtension "html"
        compile $ pandocCompilerWithTransformM localReaderOptions (defaultHakyllWriterOptions {writerHTMLMathMethod = MathJax "", writerHighlightStyle = Just pandocCodeStyle }) (\b -> evalStateT (walkM tikzFilter b) 1)
            >>= loadAndApplyTemplate "templates/post.html"    (postCtxWithTags tags)
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" (mathCtx <> postCtxWithTags tags)
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" (archiveCtx <> mathCtx)
                >>= relativizeUrls


    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll "posts/*"
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" (indexCtx <> mathCtx)
                >>= relativizeUrls

    match ("templates/*.html" .||. "templates/*.tex")  $ compile templateCompiler

    atomRule
    rssRule

--------------------------------------------------------------------------------


postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx

--------------------------------------------------------------------------------

config :: Configuration
config = defaultConfiguration
  { destinationDirectory = "docs"
  }
--------------------------------------------------------------------------------

-- based on http://qnikst.github.io/posts/2013-02-04-hakyll-latex.html
-- and   on https://gisli.hamstur.is/2020/08/my-personal-hakyll-cheatsheet/#katex-to-render-latex-math
mathCtx :: Context a
mathCtx = field "mathjax" $ \item -> do
    mathjax <- getMetadataField (itemIdentifier item) "mathjax"
    pure $ case mathjax of
        Just "off" -> ""
        Just "false" -> ""
        Nothing -> ""
        _ -> "\n<script type=\"text/javascript\" src=\"https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\"></script>"

localReaderOptions :: ReaderOptions
localReaderOptions = let defExts = readerExtensions defaultHakyllReaderOptions in defaultHakyllReaderOptions {
        readerExtensions = defExts <> extensionsFromList [Ext_emoji, Ext_tex_math_dollars, Ext_tex_math_double_backslash, Ext_latex_macros]
    }


----------------

-- based on https://rebeccaskinner.net/posts/2021-01-31-hakyll-syntax-highlighting.html

pandocCodeStyle :: Style
pandocCodeStyle = haddock


-- based on https://taeer.bar-yam.me/blog/posts/hakyll-tikz/

tikzFilter :: Block -> StateT Int Compiler Block
tikzFilter b@(CodeBlock (id_, "tikzpicture":extraClasses, namevals) contents) = do
    cur <- get
    put $ cur + 1
    lift $ do
        fName <- toFilePath <$> getUnderlying
        debugCompiler $ "saw image " <> show cur <> " for file " <> fName
        let imageBlock fname = Para [Image (id_, "tikzpicture":extraClasses, namevals) [] (fname, "")] in
            (imageBlock . Text.pack . ("data:image/svg+xml;utf8," <>) .  URI.encode . filter (/= '\n') . itemBody <$>) $
            makeItem (Text.unpack contents)
                >>= loadAndApplyTemplate (fromFilePath "templates/tikz.tex") (bodyField  "body")
                >>= withItemBody (mkTzCompiler2 fName cur)

{-tikzFilter (CodeBlock (id_, "tikzpicture":extraClasses, namevals) contents) =
  (imageBlock . Text.pack . ("data:image/svg+xml;utf8," <>) .  URI.encode . filter (/= '\n') . itemBody <$>) $
    makeItem (Text.unpack contents)
     >>= loadAndApplyTemplate (fromFilePath "templates/tikz.tex") (bodyField  "body")
     >>= withItemBody mkTzCompiler
  where imageBlock fname = Para [Image (id_, "tikzpicture":extraClasses, namevals) [] (fname, "")]
-}
tikzFilter x = return x


mkTzCompiler :: String -> Compiler String
mkTzCompiler contents = do
    baseLoc <- unsafeCompiler $
        windowize <$> writeTempFile "_latex" ".tex" contents

    debugCompiler $ "temp tex file: " <> baseLoc
    let svgLoc = newExtension "svg" baseLoc

    made <- execCompilerWith
        (execName "make")
        [ProcArg svgLoc] -- what make has to create
        (COutFile $ SpecificPath svgLoc) -- expected by hakyll
    pure $ itemBody $ fmap LBS.unpack made



mkTzCompiler2 :: FilePath -> Int -> String -> Compiler String
mkTzCompiler2 source counter contents = do
    let texName = mkTexName source counter
    unsafeCompiler $ do
        exists <- doesFileExist texName
        if exists
            then do
            existing <- readFile texName
            unless (existing == contents) $ do
                writeFile texName contents
            else do
                writeFile texName contents

    debugCompiler $ "temp tex file: " <> texName
    svgContents <- unsafeCompiler $ buildSvg texName
    itemBody . itemSetBody svgContents <$> getResourceString
    -- loadBody (fromFilePath svgPath)


-- | strips leading ".\" and replaces backslashes with slashes
windowize :: String -> String
windowize ('.' : '\\' : xs) = windowize xs
windowize xs = map (\x -> if x == '\\' then '/' else x) xs

