import { RequestHandler } from "express";
import createHttpError from "http-errors";
import mongoose from "mongoose";
import NoteModel from "../models/note";

export const getNotes: RequestHandler = async (_req, res, next) => {
  try {
    const notes = await NoteModel.find().exec();
    res.status(200).json(notes);
  } catch (error) {
    next(error);
  }
};

export const getNote: RequestHandler = async (req, res, next) => {
  const noteId = req.params.noteId;
  try {
    if (!mongoose.isValidObjectId(noteId)){
        throw createHttpError(400, "keine gültige Notiz ID")
    }
    const note = await NoteModel.findById(noteId).exec();
    if (!note) {
      throw createHttpError(404, "die Notiz nicht gefunden");
    }

    res.status(200).json(note);
  } catch (error) {
    next(error);
  }
};

interface CreateNoteBody {
  title?: string;
  text?: string;
}

export const createNote: RequestHandler<
  unknown,
  unknown,
  CreateNoteBody,
  unknown
> = async (req, res, next) => {
  const { title, text } = req.body;

  try {
    if (!title) {
      throw createHttpError(400, "die Notiz benötigt einen Title");
    }

    const newNote = await NoteModel.create({
      title,
      text,
    });

    res.status(201).json(newNote);
  } catch (error) {
    next(error);
  }
};

interface UpdateNoteParams{
    noteId:string
}

interface UpdateNoteBody {
    title?: string;
    text?: string;
  }
export const updateNote: RequestHandler<UpdateNoteParams, unknown, UpdateNoteBody, unknown> =async (req, res, next) => {
    const noteId=req.params.noteId
    const newTitle=req.body.title
    const newText=req.body.text
    try {
        if (!mongoose.isValidObjectId(noteId)){
            throw createHttpError(400, "keine gültige Notiz ID")
        }
        if (!newTitle) {
            throw createHttpError(400, "die Notiz benötigt einen Title");
          }
          const note=await NoteModel.findById(noteId).exec()
          if (!note) {
            throw createHttpError(404, "die Notiz nicht gefunden");
          }
          note.title=newTitle
          note.text=newText
          const updatedNote =await note.save()

          res.status(200).json(updatedNote)
    } catch (error) {
        next(error);
    }
}

export const deleteNote: RequestHandler=async(req, res, next)=>{
    const noteId=req.params.noteId
    try {
        if (!mongoose.isValidObjectId(noteId)){
            throw createHttpError(400, "keine gültige Notiz ID")
        }

        const note=await NoteModel.findById(noteId).exec()
        if(!note){
            throw createHttpError(404, "Notitz nicht gefunden")

        }

        await NoteModel.findByIdAndRemove(noteId).exec()
        res.sendStatus(204)
    } catch (error) {
        next(error);
    }
}