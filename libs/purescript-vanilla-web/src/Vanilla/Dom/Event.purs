{-
    | Event type, EventTarget class and methods concerning them. Related entries:
    | - [EventTarget](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget)
    | - [Event](https://developer.mozilla.org/en-US/docs/Web/API/Event)
-}
module Vanilla.Dom.Event
    ( Event, eventTarget
    , class EventTarget, addEventListener, removeEventListener, dispatchEvent
    , unsafeAddEventListener, unsafeRemoveEventListener, unsafeDispatchEvent
    , AnyEventTarget, class FromEventTarget, fromEventTarget, fromEventTarget'
    ) where

import Prelude
import Data.Maybe (Maybe, fromJust)
import Effect     (Effect)
import Partial.Unsafe (unsafePartial)
import Effect.Uncurried ( EffectFn3, EffectFn2, EffectFn1
                        , runEffectFn3, runEffectFn2, mkEffectFn1
                        )


-- | Type of js events that we can listen to
foreign import data Event :: Type

-- | Get `target` property of event.
-- | [Event.target](https://developer.mozilla.org/en-US/docs/Web/API/Event/target)
foreign import eventTarget :: Event -> AnyEventTarget


-- | Class of objects that can have events
class EventTarget a where
    -- [addEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener)
    addEventListener :: String -- ^ Event type (like `click`)
                     -> (Event -> Effect Unit) -- ^ Callback
                     -> a -- ^ Target
                     -> Effect Unit
    -- [removeEventListener](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/removeEventListener)
    removeEventListener :: String -- ^ Event type (like `click`)
                        -> (Event -> Effect Unit) -- ^ Callback
                        -> a -- ^ Target
                        -> Effect Unit
    -- [dispatchEvent](https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/dispatchEvent)
    dispatchEvent :: Event -- ^ Event to dispatch
                  -> a
                  -> Effect Boolean

-- JS implementation of those methods
foreign import addListener :: forall a.
    EffectFn3 String (EffectFn1 Event Unit) a Unit
foreign import removeListener :: forall a.
    EffectFn3 String (EffectFn1 Event Unit) a Unit
foreign import dispatch :: forall a.
    EffectFn2 Event a Boolean
-- | Default JS implementation of EventTarget methods. Use these to quickly
-- | create instances for conforming foreign types.
unsafeAddEventListener :: forall a.
    String -> (Event -> Effect Unit) -> a -> Effect Unit
unsafeAddEventListener tpe = runEffectFn3 addListener tpe <<< mkEffectFn1
-- | Same as above
unsafeRemoveEventListener :: forall a.
    String -> (Event -> Effect Unit) -> a -> Effect Unit
unsafeRemoveEventListener tpe = runEffectFn3 removeListener tpe <<< mkEffectFn1
-- | Same as above
unsafeDispatchEvent :: forall a. Event -> a -> Effect Boolean
unsafeDispatchEvent = runEffectFn2 dispatch


-- | Polymorphic type for EventTarget return values
foreign import data AnyEventTarget :: Type
instance anyEventTarget :: EventTarget AnyEventTarget where
    addEventListener = unsafeAddEventListener
    removeEventListener = unsafeRemoveEventListener
    dispatchEvent = unsafeDispatchEvent

-- | Class to get concrete type of event target. Instances are to be created
-- | with JS.
class FromEventTarget a where
    fromEventTarget :: AnyEventTarget -> Maybe a
-- | Unsafe wrapper
fromEventTarget' :: forall a. FromEventTarget a => AnyEventTarget -> a
fromEventTarget' et = unsafePartial $ fromJust $ fromEventTarget et
