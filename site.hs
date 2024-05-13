--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import           Hakyll
import           Text.Pandoc.Extensions
import           Text.Pandoc.Highlighting (Style, haddock, styleToCss)
import           Text.Pandoc.Options

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
        compile $ pandocCompilerWith localReaderOptions (defaultHakyllWriterOptions {writerHTMLMathMethod = MathJax "", writerHighlightStyle = Just pandocCodeStyle })
            >>= loadAndApplyTemplate "templates/post.html"    (postCtxWithTags tags)
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

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    defaultContext

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
        _ -> "\n<script type=\"text/javascript\" src=\"http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML\"></script>"

localReaderOptions :: ReaderOptions
localReaderOptions = let defExts = readerExtensions defaultHakyllReaderOptions in defaultHakyllReaderOptions {
        readerExtensions = defExts <> extensionsFromList [Ext_emoji, Ext_tex_math_dollars, Ext_tex_math_double_backslash, Ext_latex_macros]
    }


----------------

-- based on https://rebeccaskinner.net/posts/2021-01-31-hakyll-syntax-highlighting.html

pandocCodeStyle :: Style
pandocCodeStyle = haddock