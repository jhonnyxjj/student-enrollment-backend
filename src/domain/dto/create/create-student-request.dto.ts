import { IsString, IsNotEmpty, IsDateString } from 'class-validator';
import { CreateEnrollmentRequestDTO } from "./create-enrollment-request.DTO";

export class CreateStudentRequestDTO{
    @IsString()
    @IsNotEmpty()
    name!: string;

    @IsString()
    @IsNotEmpty()
    phone!: string;

    @IsDateString()
    birthDate!: Date;
}

export interface StudentWithEnrollmentsDTO extends CreateStudentRequestDTO {
  enrollments: CreateEnrollmentRequestDTO[];
}
