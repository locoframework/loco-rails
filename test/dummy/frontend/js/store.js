import { createStore } from "redux";

import reducer from "reducers";

const store = createStore(reducer, { articles: [], comments: {}, users: [] });

export default store;
