import React, { useEffect, useState } from 'react';
import styles from "./styles/NotesPage.module.css";

import { Note as NoteModel} from './models/note';
import Note from './components/Notes';
import { Button, Col, Container, Row, Spinner } from 'react-bootstrap';
import *as NotesApi from "./Network/notes_api";
import AddNoteDialog from './components/add_note';
import {FaPlus} from "react-icons/fa";
import AddEditNoteDialog from './components/add_note';
import SignUpModel from './components/form/signUpmodel';
import LoginModal from './components/form/loginmodel';
import NavBar from './components/NavBar';
import { User } from './models/user';

import { BrowserRouter, Route, Routes } from 'react-router-dom';
import NotesPage from './Pages/notespage';
import DatenschutzPage from './Pages/DatenschutzPage';
import NotFoundPage from './Pages/NotFoundPage';
import Kontakt from './Pages/Kontakt';
import Footer from './components/FooterBar'; 

function App() {


const[loggedInUser, setLoggedInUser]=useState<User|null>(null)

const [showSignUpModal, setShowSignUpModal]=useState(false)
const [showLoginUpModal, setShowLoginModal]=useState(false)

useEffect(()=>{
  async function fetchLoggedInUser() {
    try {
      const user=await NotesApi.getLoggedInUser()
      setLoggedInUser(user)
    } catch (error) {
      console.error(error)
    }
  }
  fetchLoggedInUser()
},[])
  
return (

  <BrowserRouter>

  <div>
    <NavBar
    loggedInUser={loggedInUser}
    onLoginClicked={()=>setShowLoginModal(true)}
    onSignUpClicked={()=>setShowSignUpModal(true)}
    onLogoutSuccessful={()=>setLoggedInUser(null)}
    />
  <Container >
   <Routes>
    <Route
    path='/'
    element={<NotesPage loggedInUser={loggedInUser}/>}
    />
    <Route
    path='/Datenschutz'
    element={<DatenschutzPage />}
    />
     <Route
    path='/Kontakt'
    element={<Kontakt />}
    />
    <Route 
    path='/*'
    element={<NotFoundPage/>}
    />
   </Routes>
  </Container>
  <Footer /> {/* Add this line here */}
  {showSignUpModal &&
  <SignUpModel
  onDismiss={()=>setShowSignUpModal(false)}
  onSignUpSuccessful={(user)=>{
    setLoggedInUser(user)
    setShowSignUpModal(false)
  }}
  />}
   {showLoginUpModal&&
  <LoginModal
  onDismiss={()=>setShowLoginModal(false)}
  onLonginSuccessful={(user)=>{ setLoggedInUser(user)
  setShowLoginModal(false)
  }}
  />}
  </div>
  </BrowserRouter>
  );
  }
  
  export default App;
          