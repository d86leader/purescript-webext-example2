module ContentScript (main) where

import Prelude
import Browser.Event (addListener)
import Browser.Runtime (onMessage)
import ContentScript.Foreign (scriptHasRun, setScriptHasRun)
import Effect (Effect)
import Vanilla.Dom.Document (createElement, body)
import Vanilla.Dom.Element (setStyle, setAttribute, remove, classList)
import Vanilla.Dom.Node (appendChild, querySelectorAll, traverseNodeList, fromNode')
import Vanilla.Dom.TokenList (tokenListAdd)

-- import Effect.Console as Console


main :: Effect Unit
main = do
    hasRun <- scriptHasRun
    if hasRun
    then pure unit
    else setScriptHasRun *> addListener handleMessage onMessage

handleMessage :: {command :: String, beastURL :: String} -> Effect Unit
handleMessage msg = case msg.command of
    "beastify" -> insertBeast msg.beastURL
    "reset"    -> removeExistingBeasts
    _ -> pure unit


removeExistingBeasts :: Effect Unit
removeExistingBeasts = do
    let nodes = querySelectorAll ".beastify-image" body
    traverseNodeList (remove <<< fromNode') nodes


insertBeast :: String -> Effect Unit
insertBeast url = do
    -- basic creation
    image <- createElement "img"
    setAttribute "src" image url
    setStyle "height" image "100vh"
    -- set correct class
    tokenListAdd "beastify-image" <<< classList $ image
    -- finalize creation
    _ <- appendChild body image
    pure unit
