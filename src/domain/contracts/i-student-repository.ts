import { Student } from "../entities";

export interface IStudentsRepository {
    findAll(): Promise<Student[]>;
    findById(id: string): Promise<Student | null>;
    create(student: Student): Promise<void>;
    update(id: string, student: Student): Promise<void>;
    delete(id: string): Promise<void>;
}
