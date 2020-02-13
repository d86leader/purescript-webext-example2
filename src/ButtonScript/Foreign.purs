{-
    | WebExtenstions bindings and other js stuff
-}
module ButtonScript.Foreign
    ( Element, document, querySelector, elementTextContent
    , Event, eventTarget
    , addEventListener
    , ClassList, elementClassList, classListHas, classListAdd, classListRemove
    , WETab, tabsQuery, tabId
    , insertTabCss, removeTabCss
    , sendTabMessage
    , injectContentScript, extensionGetUrl
    ) where

import Prelude
import Effect (Effect)
import Effect.Promise (Promise)
import Effect.Uncurried ( EffectFn3, EffectFn2, EffectFn1
                        , runEffectFn3, runEffectFn2, mkEffectFn1
                        )
import Data.Function.Uncurried (Fn2, runFn2)


-- | Type of various dom elements
foreign import data Element :: Type
-- | The document itself
foreign import document :: Element
-- | Query element of DOM
querySelector
    :: Element -- ^ Search in children of this element
    -> String -- ^ Query string
    -> Effect Element
querySelector = runEffectFn2 querySelector_
foreign import querySelector_ ::
    EffectFn2
        Element
        String
        Element


-- | Type of js events that we can listen to
foreign import data Event :: Type
-- | Wrapper for js `addEventListener` method
addEventListener
    :: Element -- ^ Element to listen on
    -> String -- ^ Event type (like `click`)
    -> (Event -> Effect Unit) -- ^ Callback
    -> Effect Unit
addEventListener target eventType cb =
    runEffectFn3 addEventListener_
        target
        eventType
        (mkEffectFn1 cb)
foreign import addEventListener_ ::
    EffectFn3
        Element
        String
        (EffectFn1 Event Unit)
        Unit
-- | Target of the received event
foreign import eventTarget :: Event -> Element


-- | WebExtensions tabs
foreign import data WETab :: Type
-- | Query tabs on some parameters. Idk the record fields
foreign import tabsQuery :: forall r.
       { | r}
    -> Promise (Array WETab)
-- | Get Tab id
foreign import tabId :: WETab -> Int


-- | Class list is not a simple array, oh no
foreign import data ClassList :: Type
-- | List of element CSS classes
foreign import elementClassList :: Element -> ClassList
-- | Check if class is in class list
classListHas :: ClassList -> String -> Boolean
classListHas = runFn2 classListHas_
foreign import classListHas_ :: Fn2 ClassList String Boolean
-- | Add class to list
classListAdd :: ClassList -> String -> Effect Unit
classListAdd = runEffectFn2 classListAdd_
foreign import classListAdd_ ::
    EffectFn2 ClassList String Unit
-- | Remove class from list
classListRemove :: ClassList -> String -> Effect Unit
classListRemove = runEffectFn2 classListRemove_
foreign import classListRemove_ ::
    EffectFn2 ClassList String Unit


-- | Inserts css text into active tab
foreign import insertTabCss :: forall r.
       {code :: String | r}
    -> Promise Unit
-- | Removes css text from active tab
foreign import removeTabCss :: forall r.
       {code :: String | r}
    -> Promise Unit

-- | Send message to WebExtensions code in tab
sendTabMessage :: forall r.
       Int -- ^ Tab id
    -> { | r} -- ^ Message data
    -> Promise Unit
sendTabMessage = runFn2 sendTabMessage_
foreign import sendTabMessage_ :: forall r.
    Fn2 Int { | r} (Promise Unit)


-- | Run JS code in current tab
foreign import injectContentScript :: String -> Promise Unit
-- | Get resolved url to extension resource
foreign import extensionGetUrl :: String -> String
-- | Get text content of DOM element
foreign import elementTextContent :: Element -> String
