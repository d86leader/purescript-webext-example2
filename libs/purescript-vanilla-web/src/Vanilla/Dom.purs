{-
    | Everything related to DOM manipulations, DOM elements and events
-}
module Vanilla.Dom
    ( Element, document, querySelector, textContent
    ) where

import Effect (Effect)
import Effect.Uncurried (EffectFn2, runEffectFn2)


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

-- | Get text content of DOM element
foreign import textContent :: Element -> String
