module ContentScript.Foreign
    ( scriptHasRun, setScriptHasRun
    , createElement, setElementAttribute, setElementStyle
    , appendBodyElement, removeMatchingElements
    , addMessageListener
    ) where

import ButtonScript.Foreign (Element)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Uncurried ( EffectFn3, EffectFn1
                        , runEffectFn3, mkEffectFn1, runEffectFn1
                        )

foreign import setProperty_ :: forall a. EffectFn3 a String String Unit
setProperty :: forall a. String -> String -> a -> Effect Unit
setProperty s v x = runEffectFn3 setProperty_ x s v

-- | Guard to check for script running a second time
foreign import scriptHasRun :: Effect Boolean
-- | Set guard after launching the script
foreign import setScriptHasRun :: Effect Unit


-- | Create new dom element with given name (like "img")
createElement :: String -> Effect Element
createElement = runEffectFn1 createElement_
foreign import createElement_ :: EffectFn1 String Element
-- | Set attribute of dom element (like "src" for img)
setElementAttribute :: String -> String -> Element -> Effect Unit
setElementAttribute = runEffectFn3 setElementAttribute_
foreign import setElementAttribute_ :: EffectFn3 String String Element Unit
-- | Set the created element as child of body
appendBodyElement :: Element -> Effect Unit
appendBodyElement = runEffectFn1 appendBodyElement_
foreign import appendBodyElement_ :: EffectFn1 Element Unit
-- | Removes elements matching a query string from page
removeMatchingElements :: String -> Effect Unit
removeMatchingElements = runEffectFn1 removeMatchingElements_
foreign import removeMatchingElements_ :: EffectFn1 String Unit
-- | Set element style parameter. I think this is only used on non-appended elements?
setElementStyle :: String -> String -> Element -> Effect Unit
setElementStyle = runEffectFn3 setElementStyle_
foreign import setElementStyle_ :: EffectFn3 String String Element Unit


addMessageListener :: forall d. ({ | d} -> Effect Unit) -> Effect Unit
addMessageListener cb = runEffectFn1 addMessageListener_ (mkEffectFn1 cb)
foreign import addMessageListener_ :: forall d.
    EffectFn1 (EffectFn1 { | d} Unit) Unit
