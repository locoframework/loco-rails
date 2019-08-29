import { createStore } from "redux";

import reducer from "reducers/main";

const store = createStore(reducer, { articles: [], comments: {} });

export default store;
