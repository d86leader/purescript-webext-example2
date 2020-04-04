module ContentScript (main) where

import Prelude
import Browser.Event (addListener)
import Browser.Runtime (onMessage)
import ContentScript.Foreign (scriptHasRun, setScriptHasRun)
import Effect (Effect)
import Vanilla.Dom.Document (createElement, body)
import Vanilla.Dom.Element (setStyle, remove, classList)
import Vanilla.Dom.Node (appendChild, querySelectorAll, traverseNodeList, fromNode')
import Vanilla.Dom.TokenList (tokenListAdd)

import Effect.Console as Console


main :: Effect Unit
main = do
    hasRun <- scriptHasRun
    if hasRun
    then Console.log "Script already ran"
    else Console.log "Running for the first time" *> setScriptHasRun *> addListener handleMessage onMessage

handleMessage :: {command :: String, beastURL :: String} -> Effect Unit
handleMessage msg = Console.log "handling message" *> case msg.command of
    "beastify" ->
        Console.log "Beastifying"
        *> insertBeast msg.beastURL
    "reset"    ->
        Console.log "Resetting"
        *> removeExistingBeasts
    _ -> pure unit


removeExistingBeasts :: Effect Unit
removeExistingBeasts = traverseNodeList (remove <<< fromNode') $
    querySelectorAll ".beastify-image" body


insertBeast :: String -> Effect Unit
insertBeast url = do
    -- basic creation
    image <- createElement "img"
    setStyle "src" image url
    setStyle "height" image "100vh"
    -- set correct class
    let classes = classList image
    tokenListAdd "beastify-image" classes
    -- finalize creation
    void $ appendChild body image
