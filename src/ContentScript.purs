module ContentScript (main) where

import Prelude
import Browser.Runtime (addMessageListener)
import Effect (Effect)
import Message (messageRepr, MessageData)
import Vanilla.Dom.Document (createElement, body)
import Vanilla.Dom.Element (setStyle, setAttribute, remove, classList)
import Vanilla.Dom.Node (appendChild, querySelectorAll, traverseNodeList, fromNodeEx)
import Vanilla.Dom.TokenList (tokenListAdd)
import Vanilla.Dom.Window (getCustomAttribute, setCustomAttribute)

import Effect.Console as Console


main :: Effect Unit
main = do
    hasRun <- getCustomAttribute "hasRun" false
    if hasRun
    then Console.log "Script already ran"
    else setCustomAttribute "hasRun" true
      *> addMessageListener messageRepr handleMessage

handleMessage :: forall sr sd.
    {message :: MessageData, sender :: sd, sendResponse :: sr} -> Effect Boolean
handleMessage msg' = Console.log "message!" *>
    let msg = msg'.message
        action = case msg.command of
            "beastify" -> insertBeast msg.beastURL
            "reset"    -> removeExistingBeasts
            _ -> pure unit
    in action *> pure false


removeExistingBeasts :: Effect Unit
removeExistingBeasts = do
    Console.log "removing beasts"
    let nodes = querySelectorAll ".beastify-image" body
    flip traverseNodeList nodes \node -> do
       remove <<< fromNodeEx $ node
       Console.log "removed beast"


insertBeast :: String -> Effect Unit
insertBeast url = do
    Console.log "inserting a beast"
    -- basic creation
    image <- createElement "img"
    setAttribute "src" image url
    setStyle "height" image "100vh"
    -- set correct class
    tokenListAdd "beastify-image" <<< classList $ image
    -- finalize creation
    _ <- appendChild body image
    Console.log "appended new image?"
    pure unit
