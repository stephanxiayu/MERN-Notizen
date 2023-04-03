import React, { useEffect, useState } from 'react';
import styles from "./styles/NotesPage.module.css";

import { Note as NoteModel} from './models/note';
import Note from './components/Notes';
import { Button, Col, Container, Row } from 'react-bootstrap';
import *as NotesApi from "./Network/notes_api";
import AddNoteDialog from './components/add_note';
import {FaPlus} from "react-icons/fa";
import AddEditNoteDialog from './components/add_note';


///*******
/// line 50 is still a problem
///*******


function App() {

const [notes, setNotes]= useState<NoteModel[]>([]);
 
const [showAddNoteDialog,setShowAddNoteDialog ]=useState(false)
const [noteToEdit, setNoteToEdit]=useState<NoteModel|null>(null)

useEffect( () => {

  async function loadNotes() {
    try {
    const notes= await NotesApi.fetchNotes()
      setNotes(notes)
    } catch (error) {
      console.error(error)
      alert(error)
    }
   
  }
loadNotes()
}, 
[]);

async function deleteNote(note:NoteModel) {

  try {
    await NotesApi.deleteNote(note._id)
    setNotes(notes.filter(existingNote=>existingNote._id!==note._id))
  } catch (error) {
    console.error(error)
    alert(error)
  }
  
}

  return (
   
    <Container>
      <Button  className={`mb-4 ${styles.blockCenter} ${styles.flexCenter}`}  variant="secondary" size="lg" active onClick={()=>setShowAddNoteDialog(true)}>
      <FaPlus/>
        Notiz hinzufügen
      </Button>
      <Row xs={2} md={2} xl={4} className="g-100">

     
    {notes.map(note => (
      <Col key={note._id}>
      <Note 
      note={note} className={styles.note}
      onNoteClicked={(note)=>setNoteToEdit(note)}
      onDeleteNoteClick={deleteNote}
      />
      </Col>
    ))}
     </Row>
     {
      showAddNoteDialog&&
      <AddEditNoteDialog 
      onDismiss={ ()=>setShowAddNoteDialog(false) }
      onNoteSaved={(newNote)=>{
       // ich habe keine Lösung gefunden, momentan muss man die Seite refresen 4:29 im Video
        setNotes([...notes, 
           newNote 
        ])
      
        setShowAddNoteDialog(false)
      
      }}
      
      />
     }
     {noteToEdit&&
     <AddEditNoteDialog
     noteToEdit={noteToEdit}
     onDismiss={()=>setNoteToEdit(null)}
     onNoteSaved={(updatedNote)=>{
      // ich habe keine Lösung gefunden, momentan muss man die Seite refresen 4:29 im Video
       setNotes(notes.map(existingNote=>existingNote._id===updatedNote._id?updatedNote:existingNote))
      setNoteToEdit(null
        
       )
     
       setShowAddNoteDialog(false)
     
     }}
     />
     }
    </Container>
  );
}

export default App;
