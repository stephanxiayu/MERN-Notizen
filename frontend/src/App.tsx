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
import NotePageLoggedin from './components/NotePageLoggedin';
import NotePageLoggedoutview from './components/NotePageLoggedoutview';


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
    <>
      {/* {notesLoading &&
        <div className="progress" style={{ position: 'fixed', top: 0, width: '100%', height: '4px', backgroundColor: 'darkgrey', zIndex: 9999 }}>
          <div className="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style={{ width: '100%', backgroundColor: 'red' }}></div>
        </div>
      } */}

      <div>
        <NavBar
        loggedInUser={loggedInUser}
        onLoginClicked={()=>setShowLoginModal(true)}
        onSignUpClicked={()=>setShowSignUpModal(true)}
        onLogoutSuccessful={()=>setLoggedInUser(null)}


        />
      <Container >
          <>
          {loggedInUser?
          <NotePageLoggedin/>
          : <NotePageLoggedoutview/>
          }
          </>
         
          </Container>
          {showSignUpModal&&
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
          </>
          );
          }
          
          export default App;
          