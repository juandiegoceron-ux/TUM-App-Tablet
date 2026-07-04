import React, { useState } from 'react'
import Welcome from './components/Welcome'
import Login from './components/Login'
import Dashboard from './components/Dashboard'

function App() {
  const [page, setPage] = useState('welcome')
  const [user, setUser] = useState({
    name: 'Jorge Guzmán',
    email: 'jorgeguzman@gmail.com'
  })

  return (
    <div className="app-container">
      {page === 'welcome' && (
        <Welcome onStart={() => setPage('login')} />
      )}
      {page === 'login' && (
        <Login 
          onLogin={(userData) => {
            setUser(userData);
            setPage('dashboard');
          }} 
          onBack={() => setPage('welcome')}
        />
      )}
      {page === 'dashboard' && (
        <Dashboard 
          user={user} 
          onLogout={() => {
            setUser(null);
            setPage('welcome');
          }} 
        />
      )}
    </div>
  )
}

export default App
