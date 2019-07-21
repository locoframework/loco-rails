import { createStore } from "redux";

import reducer from "reducers/user";

const store = createStore(reducer, { articles: [] });

export default store;
