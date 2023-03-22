import React from 'react';
import logo from './logo.png';
import './App.css';

function App() {
  const ec2InstanceName = 'demo-cours-centrale-nantes';

  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <p>
          Bonjour de {ec2InstanceName}
        </p>
      </header>
    </div>
  );
}

export default App;
