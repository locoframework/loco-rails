import getEnv from "initializers/loco-core";

import {
  created as articleCreated,
  published as articlePublished,
  updated as articleUpdated,
  commentsUpdated,
} from "actions/articles";

import {
  created as commentCreated,
  destroyed as commentDestroyed,
  updated as commentUpdated,
} from "actions/comments";

import {
  created as userCreated,
  confirmed as userConfirmed,
} from "actions/users";

import { inChatRoom, userNamespace } from "services/namespace";

const ping = () => {
  if (!userNamespace()) return;
  alert("Ping!");
};

const getCallbackForNewMessage = () => {
  if (!inChatRoom()) return () => {};
  return getEnv().controller.view.receivedMessage;
};

const wsDisconnected = () => {
  if (inChatRoom()) getEnv().controller.view.disconnected();
};

export default async (data) => {
  if (data.loco !== undefined) {
    switch (data.loco) {
      case "disconnected":
        wsDisconnected();
        break;
    }
  }
  switch (data.type) {
    case "PING":
      ping();
      break;
    case "NEW_MESSAGE":
      getCallbackForNewMessage()(data.message, data.author);
      break;
    case "Article created":
      articleCreated(data.payload);
      break;
    case "Article published":
      articlePublished(data.payload);
      break;
    case "Article updated":
      articleUpdated(data.payload);
      break;
    case "Article.Comment created":
      commentCreated(data.payload);
      break;
    case "Article.Comment destroyed":
      commentsUpdated(data.payload, -1);
      commentDestroyed(data.payload);
      break;
    case "Article.Comment updated":
      commentUpdated(data.payload);
      break;
    case "User created":
      userCreated(data.payload);
      break;
    case "User confirmed":
      userConfirmed(data.payload);
      break;
  }
};
