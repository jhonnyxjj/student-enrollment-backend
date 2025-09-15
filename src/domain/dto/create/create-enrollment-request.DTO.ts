import { IsString, IsNotEmpty, IsDateString, IsNumber } from 'class-validator';

export class CreateEnrollmentRequestDTO {
    @IsString()
    @IsNotEmpty()
    enrollmentCode!: string;

    @IsString()
    @IsNotEmpty()
    courseName!: string;

    @IsDateString()
    startDate!: Date;

    @IsNumber()
    studentId!: number;
}



