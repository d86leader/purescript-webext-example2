module ButtonScript (main) where

import Effect (Effect)
import Effect.Exception (Error, message, error)
import Effect.Promise (class Deferred, Promise, runPromise, reject)
import ButtonScript.Foreign
    ( document, querySelector, elementTextContent
    , Event, eventTarget
    , addEventListener
    , elementClassList, classListHas, classListAdd, classListRemove
    , WETab, tabsQuery, tabId
    , insertTabCss, removeTabCss
    , sendTabMessage
    , injectContentScript, extensionGetUrl
    )

import Effect.Console as Console

import Prelude

reportScriptError :: Error -> Effect Unit
reportScriptError err = do
    flip classListAdd    "hidden" =<< map elementClassList
        (querySelector document "#popup-content")
    flip classListRemove "hidden" =<< map elementClassList
        (querySelector document "#error-content")


main :: Effect Unit
main = do
    runPromise pure reportScriptError
        (injectContentScript "/build/content_script.js")
    addEventListener document "click" buttonClicked


buttonClicked :: Event -> Effect Unit
buttonClicked ev = runPromise pure report (buttonClicked' ev)
    where report e = Console.error $ "Failed to beastify: " <> message e
buttonClicked' :: Deferred => Event -> Promise Unit
buttonClicked' event =
    let target = eventTarget event
        targetClasses = elementClassList target
    in case unit of
        _ | targetClasses `classListHas` "beast" -> do
              tabs <- tabsQuery {active: true, currentWindow: true}
              let content = elementTextContent target
              beastify content tabs
          | targetClasses `classListHas` "reset" -> do
              tabs <- tabsQuery {active: true, currentWindow: true}
              let content = elementTextContent target
              reset tabs
        otherwise -> pure unit



beastNameToUrl :: String -> String
beastNameToUrl name =
    let imageName = case name of
         "Frog"  -> "frog.jpg"
         "Snake" -> "snake.jpg"
         "turtle" -> "turtle.jpg"
         _ -> "404.jpg"
    in extensionGetUrl $ "resources/beasts/" <> imageName


-- | Inset page-hiding CSS into active tab, and send a beastify message to the
-- | script of argument tab (which should also be active)
beastify
    :: Deferred
    => String -- ^ Text content of button pressed
    -> Array WETab
    -> Promise Unit
beastify buttonContent tabs = do
    insertTabCss {code: hidePageCss}
    target <- case tabs of -- why no head in prelude?
        [head, _] -> pure $ tabId head
        _ -> reject $ error "Empty tab list"
    let url = beastNameToUrl buttonContent
    sendTabMessage target {command: "beastify", beastURL: url}

-- | Undo effects of beastify
reset :: Deferred => Array WETab -> Promise Unit
reset tabs = do
    removeTabCss {code: hidePageCss}
    target <- case tabs of -- why no head in prelude?
        [head, _] -> pure $ tabId head
        _ -> reject $ error "Empty tab list"
    sendTabMessage target {command: "reset"}


hidePageCss :: String
hidePageCss = """body > :not(.beastify-image) {
    display: none;
};
 """
