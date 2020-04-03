{-
    | Node class, helper types and their functions. Related entries:
    | - [Node](https://developer.mozilla.org/en-US/docs/Web/API/Node)
-}
module Vanilla.Dom.Node
    ( class Node, textContent, childNodes
    , unsafeTextContent, unsafeChildNodes
    , NodeList, nodeListLength, nodeListItem
    , AnyNode, class FromNode, fromNode, fromNode'
    , class QueryNode, querySelector
    , unsafeQuerySelector
    ) where

import Prelude
import Data.Maybe (Maybe, fromJust)
import Data.Function.Uncurried (Fn2, runFn2)
import Partial.Unsafe (unsafePartial)
import Vanilla.Dom.Event (class EventTarget)

import Vanilla.Dom.Event as Ev


-- | Class of Node objects, like Element and Document
class EventTarget a <= Node a where
    -- | Text content of node.
    -- | [Node.textContent](https://developer.mozilla.org/en-US/docs/Web/API/Node/textContent)
    textContent :: a -> String
    -- | Children of the node. Careful: this object is live and may change on
    -- | your hands.
    -- | [Node.childNodes](https://developer.mozilla.org/en-US/docs/Web/API/Node/childNodes)
    childNodes :: a -> NodeList

-- | Monomorphic container of nodes.
-- | [NodeList](https://developer.mozilla.org/en-US/docs/Web/API/NodeList)
foreign import data NodeList :: Type
foreign import nodeListLength :: NodeList -> Int
-- | Throws an exception when index out of bounds
nodeListItem :: Int -> NodeList -> AnyNode
nodeListItem = runFn2 nodeListItem_
foreign import nodeListItem_ :: Fn2 Int NodeList AnyNode

-- | Default JS implementation of Node methods. Use these to quickly
-- | create instances for conforming foreign types.
foreign import unsafeTextContent :: forall a. a -> String
foreign import unsafeChildNodes :: forall a. a -> NodeList

-- | Polymorphic type for return values
foreign import data AnyNode :: Type
instance eventTargetAnyNode :: EventTarget AnyNode where
    addEventListener = Ev.unsafeAddEventListener
    removeEventListener = Ev.unsafeRemoveEventListener
    dispatchEvent = Ev.unsafeDispatchEvent
instance anyNode :: Node AnyNode where
    textContent = unsafeTextContent
    childNodes = unsafeChildNodes

-- | Class to get concrete type of Node class. Instances are to be created with
-- | JS.
class FromNode a where
    fromNode :: AnyNode -> Maybe a
-- | Unsafe wrapper
fromNode' :: forall a. FromNode a => AnyNode -> a
fromNode' et = unsafePartial $ fromJust $ fromNode et


-- | Node which supports querySelector method, like Element and Document
class Node a <= QueryNode a where
    -- | Query child nodes.
    -- | [Element.querySelector](https://developer.mozilla.org/en-US/docs/Web/API/Element/querySelector)
    querySelector :: String -> a -> AnyNode

-- | Default JS implementation. Use these to quickly create instances for
-- | conforming foreign types.
unsafeQuerySelector :: forall a. String -> a -> AnyNode
unsafeQuerySelector = runFn2 unsafeQuerySelector_
foreign import unsafeQuerySelector_ :: forall a. Fn2 String a AnyNode
