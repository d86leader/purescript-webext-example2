{-
    | Window type and instances
    | [Window](https://developer.mozilla.org/en-US/docs/Web/API/Window)
-}
module Vanilla.Dom.Window
    ( Window, window
    , setCustomAttribute, getCustomAttribute
    ) where

import Data.Unit (Unit)
import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2, EffectFn1, runEffectFn1)

-- | Window type
foreign import data Window :: Type
-- | A global variable, window, representing the window in which the script is
-- | running
foreign import window :: Window

-- | Set a global value in window. The caller chooses types.
setCustomAttribute :: forall a.
       String -- ^ Attribute name
    -> a -- ^ Attribute value
    -> Effect Unit
setCustomAttribute = runEffectFn2 setCustomAttribute_
foreign import setCustomAttribute_ :: forall a. EffectFn2 String a Unit
-- | Get a global value in window. The caller chooses types.
getCustomAttribute :: forall a.
       String -- ^ Attribute name
    -> Effect a -- ^ Attribute value
getCustomAttribute = runEffectFn1 getCustomAttribute_
foreign import getCustomAttribute_ :: forall a. EffectFn1 String a
