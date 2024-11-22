module SvgWorks (buildSvg, mkTexName) where

import Development.Shake
import Development.Shake.FilePath
import System.Directory

-- | relative path of the tex file; returns contents of the svg file
buildSvg :: FilePath -> IO String
buildSvg fp =
    let
        fp_ = map (\c -> if c == '\\' then '/' else c ) fp
        texName = takeFileName  fp_
        svgName = fp_ -<.> "svg"
        pdfName = fp_ -<.> "pdf"
    in do
        shake shakeOptions $ do
            want [svgName]
            svgName %> \_ -> do
                -- let pdfName = out -<.> "pdf"
                need [pdfName]
                cmd_ "pdftocairo -svg" pdfName -- writes to pwd
                liftIO $ renameFile (texName -<.> "svg") svgName
            pdfName %> \_ -> do
                need [fp_]
                cmd_ "pdflatex -output-directory=_latex" fp_
                      

        readFile svgName

-- | mkTexName "post/something.md" 3 = "_latex/something-3.tex"
mkTexName :: FilePath -> Int -> FilePath
mkTexName fp c = "_latex" </> (dropExtension (takeFileName fp) <> "-" <> show c)  <.> "tex"
