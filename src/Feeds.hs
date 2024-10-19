{-# LANGUAGE OverloadedStrings #-}
module Feeds (rssRule, atomRule) where

import Hakyll
    ( loadAllSnapshots,
      idRoute,
      compile,
      create,
      route,
      renderAtom,
      bodyField,
      recentFirst,
      Rules,
      FeedConfiguration(..), renderRss )
import Utils

-- adapted from https://jaspervdj.be/hakyll/tutorials/05-snapshots-feeds.html

feedConfiguration :: FeedConfiguration
feedConfiguration = FeedConfiguration
    { feedTitle       = "SW's blogs"
    , feedDescription = "Ramblings of a mathematician turned programmer"
    , feedAuthorName  = "Shryke Windgrace"
    , feedAuthorEmail = "shryke.windgrace@gmail.com"
    , feedRoot        = "shrykewindgrace.github.io"
    }

atomRule :: Rules ()
atomRule = create ["atom.xml"] $ do
    route idRoute
    compile $ do
        let feedCtx = postCtx `mappend` bodyField "description"
        posts <- fmap (take 10) . recentFirst =<<
            loadAllSnapshots "posts/*" "content"
        renderAtom feedConfiguration feedCtx posts

rssRule :: Rules ()
rssRule = create ["rss.xml"] $ do
    route idRoute
    compile $ do
        let feedCtx = postCtx `mappend` bodyField "description"
        posts <- fmap (take 10) . recentFirst =<<
            loadAllSnapshots "posts/*" "content"
        renderRss feedConfiguration feedCtx posts
