{-
    | Element type and instances
    | [Element](https://developer.mozilla.org/en-US/docs/Web/API/Element)
-}
module Vanilla.Dom.Element
    ( Element
    , innerText, innerHtml, classList, setAttribute, remove
    , getStyle, setStyle
    ) where

import Data.Maybe (Maybe (Just, Nothing))
import Data.Function.Uncurried (Fn3, runFn3)
import Data.Unit (Unit)
import Effect (Effect)
import Effect.Uncurried (EffectFn3, runEffectFn3)
import Vanilla.Dom.Event (class EventTarget, class FromEventTarget)
import Vanilla.Dom.Node (class Node, class FromNode, class QueryNode)
import Vanilla.Dom.TokenList (TokenList)

import Vanilla.Dom.Event as Ev
import Vanilla.Dom.Node as Nd


-- | Element type, which is HTMLElement or XMLElement
foreign import data Element :: Type

-- | Rendered text of HTMLElement.
-- | [innerText](https://developer.mozilla.org/en-US/docs/Web/API/HTMLElement/innerText)
foreign import innerText :: Element -> String
-- | Raw text of HTMLElement.
-- | [innerHTML](https://developer.mozilla.org/en-US/docs/Web/API/Element/innerHTML)
foreign import innerHtml :: Element -> String
-- | Class attributes of element
-- | [classList](https://developer.mozilla.org/en-US/docs/Web/API/Element/classList)
foreign import classList :: Element -> TokenList
-- | Set (create or update) an attribute on element
-- | [setAttribute](https://developer.mozilla.org/en-US/docs/Web/API/Element/setAttribute)
setAttribute :: String -- ^ Attribute name
             -> Element -- ^ Target element
             -> String -- ^ New attribute value
             -> Effect Unit
setAttribute = runEffectFn3 setAttribute_
foreign import setAttribute_ :: EffectFn3 String Element String Unit
-- | Remove element from node tree
-- | [remove](https://developer.mozilla.org/en-US/docs/Web/API/ChildNode/remove)
foreign import remove :: Element -> Effect Unit
-- | Get style of element. The docs are all over the place, but you can start
-- | here:
-- | [style](https://developer.mozilla.org/en-US/docs/Web/API/ElementCSSInlineStyle/style)
foreign import getStyle :: String -- ^ Property name
                        -> Element -- ^ Target element
                        -> String
-- | Set style of element. For example, `setStyle "color" elem "blue"`
setStyle :: String -- ^ Property name
         -> Element -- ^ Target element
         -> String -- ^ Property value
         -> Effect Unit
setStyle = runEffectFn3 setStyle_
foreign import setStyle_ :: EffectFn3 String Element String Unit

instance elemEventTarget :: EventTarget Element where
    addEventListener = Ev.unsafeAddEventListener
    removeEventListener = Ev.unsafeRemoveEventListener
    dispatchEvent = Ev.unsafeDispatchEvent

instance elemFromEventTarget :: FromEventTarget Element where
    fromEventTarget = runFn3 fromEventTarget_ Just Nothing
foreign import fromEventTarget_ :: Fn3 (forall a. a -> Maybe a)
                                       (forall a. Maybe a)
                                       Ev.AnyEventTarget
                                       (Maybe Element)

instance elemNode :: Node Element where
    textContent = Nd.unsafeTextContent
    childNodes = Nd.unsafeChildNodes
    appendAnyChild = Nd.unsafeAppendChild

instance elemFromNode :: FromNode Element where
    fromNode = runFn3 fromNode_ Just Nothing
foreign import fromNode_ :: Fn3 (forall a. a -> Maybe a)
                                (forall a. Maybe a)
                                Nd.AnyNode
                                (Maybe Element)

instance elemQuery :: QueryNode Element where
    querySelector = Nd.unsafeQuerySelector
    querySelectorAll = Nd.unsafeQuerySelectorAll
