import React from 'react';
import { BrowserRouter as Router, Switch, Route } from 'react-router-dom';

import './App.scss';
import Login from './LoginPage/Login';
import Dashboard from './Home/Dashboard';

function App() {
  return (

    <Router>
      <Switch>
        <Route path="/" exact component={Login} />
        <Route path="/home" component={Dashboard} />
      </Switch>
    </Router>
  );
}

export default App;
