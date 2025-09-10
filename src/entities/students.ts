import { Enrollment } from "./Enrollment";

export type Student = {
    name: string;
    phone?: string;
    birthDate: Date;
    createdAt: Date;
    updatedAt?: Date;
    enrollments: Enrollment[];
};
