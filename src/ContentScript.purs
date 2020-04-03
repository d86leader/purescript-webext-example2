module ContentScript (main) where

import Browser.Event (addListener)
import Browser.Runtime (onMessage)
import ButtonScript.Foreign (elementClassList, classListAdd)
import Effect (Effect)

import ContentScript.Foreign
    ( scriptHasRun, setScriptHasRun
    , createElement, setElementAttribute, setElementStyle
    , appendBodyElement, removeMatchingElements
    )

import Prelude


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
removeExistingBeasts = removeMatchingElements ".beastify-image"


insertBeast :: String -> Effect Unit
insertBeast url = do
    -- basic creation
    image <- createElement "img"
    setElementAttribute "src" url image
    setElementStyle "height" "100vh" image
    -- set correct class
    let classes = elementClassList image
    classListAdd classes "beastify-image"
    -- finalize creation
    appendBodyElement image
