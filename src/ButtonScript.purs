module ButtonScript (main) where

import Data.Array.Partial (head)
import Effect (Effect)
import Effect.Exception (Error, message)
import Effect.Promise (class Deferred, Promise, runPromise)
import Partial.Unsafe (unsafePartial)

import ButtonScript.Foreign
    ( document, querySelector, elementTextContent
    , Event, eventTarget
    , addEventListener
    , elementClassList, classListHas, classListAdd, classListRemove
    , tabsQuery, tabId
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
    runPromise pure reportScriptError $
        injectContentScript "/build/content_script.js"
    addEventListener document "click" buttonClicked


-- | Action that runs when something on the thingy was clicked. May noy be a
-- | button, but only handles button clicks
buttonClicked :: Event -> Effect Unit
buttonClicked ev = runPromise pure report $ buttonClicked' ev
    where report e = Console.error $ "Failed to beastify: " <> message e

buttonClicked' :: Deferred => Event -> Promise Unit
buttonClicked' event =
    let target = eventTarget event
        targetClasses = elementClassList target
    in case unit of
        _ | targetClasses `classListHas` "beast" -> do
              tabs <- tabsQuery {active: true, currentWindow: true}
              let content = elementTextContent target
              beastify content
          | targetClasses `classListHas` "reset" -> do
              let content = elementTextContent target
              reset
        otherwise -> pure unit



beastNameToUrl :: String -> String
beastNameToUrl name =
    let imageName = case name of
         "Frog"  -> "frog.jpg"
         "Snake" -> "snake.jpg"
         "Turtle" -> "turtle.jpg"
         _ -> "404.jpg"
    in extensionGetUrl $ "resources/beasts/" <> imageName


-- | Inset page-hiding CSS into active tab, and send a beastify message to the
-- | script of argument tab (which should also be active)
beastify
    :: Deferred
    => String -- ^ Text content of button pressed
    -> Promise Unit
beastify buttonContent = do
    tabs <- tabsQuery {active: true, currentWindow: true}
    insertTabCss {code: hidePageCss}
    let target = tabId $ unsafePartial $ head $ tabs
    let url = beastNameToUrl buttonContent
    sendTabMessage target {command: "beastify", beastURL: url}

-- | Undo effects of beastify
reset :: Deferred => Promise Unit
reset = do
    tabs <- tabsQuery {active: true, currentWindow: true}
    removeTabCss {code: hidePageCss}
    let target = tabId $ unsafePartial $ head $ tabs
    sendTabMessage target {command: "reset"}


hidePageCss :: String
hidePageCss = """body > :not(.beastify-image) {
    display: none;
};
 """
