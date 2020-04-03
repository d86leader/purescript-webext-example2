{-
    | Element type and instances
    | [Element](https://developer.mozilla.org/en-US/docs/Web/API/Element)
-}
module Vanilla.Dom.Element
    ( Element
    , innerText, innerHtml, classList
    ) where

import Data.Maybe (Maybe (Just, Nothing))
import Data.Function.Uncurried (Fn3, runFn3)
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

instance elemFromNode :: FromNode Element where
    fromNode = runFn3 fromNode_ Just Nothing
foreign import fromNode_ :: Fn3 (forall a. a -> Maybe a)
                                (forall a. Maybe a)
                                Nd.AnyNode
                                (Maybe Element)

instance elemQuery :: QueryNode Element where
    querySelector = Nd.unsafeQuerySelector
