module Utils (postCtx) where

import Hakyll 
import           Data.Time.Clock               (UTCTime (..))
import           Data.Time.Locale.Compat       (TimeLocale, defaultTimeLocale)
import           Data.Time.Format              (formatTime, parseTimeM)
import           Control.Monad                 (msum)
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    updatedField "updated" "%B %e, %Y" `mappend`
    defaultContext

-- everything below was copypasted from
-- https://www.stackage.org/haddock/lts-23.21/hakyll-4.16.6.0/src/Hakyll.Web.Template.Context.html

getUpdItemUTC :: (MonadMetadata m, MonadFail m)
           => TimeLocale        -- ^ Output time locale
           -> Identifier        -- ^ Input page
           -> m UTCTime         -- ^ Parsed UTCTime
getUpdItemUTC locale id' = do
    metadata <- getMetadata id'
    let tryField k fmt = lookupString k metadata >>= parseTime' fmt

    maybe empty' return $ msum $
        [tryField "updated" fmt | fmt <- formats]
  where
    empty'     = fail $ "Utils.getUpdItemUTC: " ++
        "could not parse time for " ++ show id'
    parseTime' = parseTimeM True locale
    formats    =
        [ "%a, %d %b %Y %H:%M:%S %Z"
        , "%a, %d %b %Y %H:%M:%S"
        , "%Y-%m-%dT%H:%M:%S%Z"
        , "%Y-%m-%dT%H:%M:%S"
        , "%Y-%m-%d %H:%M:%S%Z"
        , "%Y-%m-%d %H:%M:%S"
        , "%Y-%m-%d"
        , "%d.%m.%Y"
        , "%B %e, %Y %l:%M %p"
        , "%B %e, %Y"
        , "%b %d, %Y"
        ]

updatedField :: String     -- ^ Key in which the rendered date should be placed
          -> String     -- ^ Format to use on the date
          -> Context a  -- ^ Resulting context
updatedField = updatedFieldWith defaultTimeLocale


--------------------------------------------------------------------------------
-- | This is an extended version of 'dateField' that allows you to
-- specify a time locale that is used for outputting the date. For more
-- details, see 'dateField' and 'formatTime'.
updatedFieldWith :: TimeLocale  -- ^ Output time locale
              -> String      -- ^ Destination key
              -> String      -- ^ Format to use on the date
              -> Context a   -- ^ Resulting context
updatedFieldWith locale key format = field key $ \i -> do
    time <- getUpdItemUTC locale $ itemIdentifier i
    return $ formatTime locale format time