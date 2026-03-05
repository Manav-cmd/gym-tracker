package com.gymtracker.model;

import java.sql.Date;

public class Workout {

    private int id;
    private int userId;
    private int exerciseId;
    private float weight;
    private int sets;
    private int reps;
    private String notes;
    private Date workoutDate;

    public Workout(){}

    public Workout(int userId, int exerciseId, float weight, int sets, int reps, String notes, Date workoutDate){
        this.userId = userId;
        this.exerciseId = exerciseId;
        this.weight = weight;
        this.sets = sets;
        this.reps = reps;
        this.notes = notes;
        this.workoutDate = workoutDate;
    }

    public int getUserId(){ return userId; }
    public int getExerciseId(){ return exerciseId; }
    public float getWeight(){ return weight; }
    public int getSets(){ return sets; }
    public int getReps(){ return reps; }
    public String getNotes(){ return notes; }
    public Date getWorkoutDate(){ return workoutDate; }
}