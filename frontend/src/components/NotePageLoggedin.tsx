import { FaPlus } from "react-icons/fa";
import AddEditNoteDialog from "./add_note";
import styles from "../styles/NotesPage.module.css";

import React, { useEffect, useState } from 'react';
import { Note as NoteModel} from '../models/note';
import { Col, Row } from "react-bootstrap";
import Note from "./Notes";
import * as NotesApi from "../Network/notes_api"
// interface NotePageLoggedinProps{

// }

const NotePageLoggedin = () => {


  const [notes, setNotes]= useState<NoteModel[]>([]);
  const [notesLoading, setNotesLoading]=useState(true);
  const [showNotesLoadingError,setShowNotesLoadingError]= useState(false)
   
  const [showAddNoteDialog,setShowAddNoteDialog ]=useState(false)
  const [noteToEdit, setNoteToEdit]=useState<NoteModel|null>(null)


  useEffect( () => {

    async function loadNotes() {
      try {
        setShowNotesLoadingError(false)
        setNotesLoading(true)
        const notes= await NotesApi.fetchNotes()
        setNotes(notes)
      } catch (error) {
        console.error(error)
        setShowNotesLoadingError(true)
      } finally{
        setNotesLoading(false)
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

  const notesGrid=
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
    return ( 
        <>
          {notesLoading &&
        <div className="progress" style={{ position: 'fixed', top: 0, width: '100%', height: '4px', backgroundColor: 'darkgrey', zIndex: 9999 }}>
          <div className="progress-bar progress-bar-striped progress-bar-animated" role="progressbar" style={{ width: '100%', backgroundColor: 'red' }}></div>
        </div>
      }
        <button style={{
    background: 'linear-gradient(90deg, #FFA500 0%, #FFFF00 50%, #FFA500 100%)',
    border: 'none',
    color: 'black',
    padding: '10px 20px',
}}
className={`${styles.mb4} ${styles.blockCenter} ${styles.flexCenter}`} onClick={()=>setShowAddNoteDialog(true)}>
    <FaPlus/>
    Notiz hinzufügen
</button>


        {showNotesLoadingError&&<p style={{ color: 'red', fontSize: 30 }}>
          Something went wrong! Well, shit happens... 
        </p> }
        {!notesLoading&& !showNotesLoadingError&& 
        <>
          {
            notes.length>0
            ?notesGrid: <p style={{ color: 'white', fontSize: 40 }}>
              Noch keine Notizen hinzugefügt
            </p>
          }
        </>
        }
        {
          showAddNoteDialog&&
          <AddEditNoteDialog 
            onDismiss={ ()=>setShowAddNoteDialog(false) }
            onNoteSaved={(newNote)=>{
              setNotes([...notes, 
                newNote 
              ])
              setShowAddNoteDialog(false)
            }}
          />
        }
        {noteToEdit&&
          <
          AddEditNoteDialog
          noteToEdit={noteToEdit}
          onDismiss={()=>setNoteToEdit(null)}
          onNoteSaved={(updatedNote)=>{
            setNotes(notes.map(existingNote=>existingNote._id===updatedNote._id?updatedNote:existingNote))
            setNoteToEdit(null)
            setShowAddNoteDialog(false)
          }}
          />
          }
        </>

     );
}
 
export default NotePageLoggedin;