import {
  BadRequestException,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { AuthDto } from './dto';
import * as argon from 'argon2';
import { PrismaClientKnownRequestError } from '@prisma/client/runtime/library';
import { JwtService } from '@nestjs/jwt';
import * as jwtEx from 'jsonwebtoken';
import { NotFoundError } from 'rxjs';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwt: JwtService,
  ) {}
  async signup(dto: AuthDto) {
    const hash = await argon.hash(dto.password);
    let model_type: any;
    let data: any;
    if (dto.role === 'customer') {
      model_type = this.prisma.user;
      data = {
        fullName: dto.fullName,
        phone: dto.phone,
        role: dto.role,
        email: dto.email,
        password: hash,
      };
    } else if (dto.role === 'technician') {
      model_type = this.prisma.technician;
      data = {
        fullName: dto.fullName,
        phone: dto.phone,
        role: dto.role,
        email: dto.email,
        skills: dto.skills,
        experience: dto.experience,
        educationLevel: dto.educationLevel,
        availableLocation: dto.availableLocation,
        additionalBio: dto.additionalBio,
        password: hash,
      };
    }
    try {
      const user = await model_type.create({
        data: data,
        select: {
          fullName: true,
          phone: true,
          role: true,
          email: true,
        },
      });
      console.log(user);
      return user;
    } catch (error) {
      if (error instanceof PrismaClientKnownRequestError) {
        if (error.code === 'P2002') {
          throw new ForbiddenException('Credetials are taken');
        } else {
          throw error;
        }
      }
    }
  }

  async signin(dto: any) {
    let user;
    console.log(dto);
    if (dto.role === 'customer') {
      user = await this.prisma.user.findUnique({
        where: {
          email: dto.email,
        },
      });
    } else if (dto.role === 'technician') {
      user = await this.prisma.technician.findUnique({
        where: {
          email: dto.email,
        },
      });
    } else if (dto.role === 'admin') {
      user = await this.prisma.admin.findUnique({
        where: {
          email: dto.email,
        },
      });
    }

    if (!user) {
      throw new ForbiddenException('Credetials are not Correct! here');
    }

    const pwMatches = await argon.verify(user.password, dto.password);

    if (!pwMatches) {
      throw new ForbiddenException('Credetials are not correct!');
    }
    if (user.role === 'technician') {
      return this.tokenGenerate(
        user.id,
        user.fullName,
        user.role,
        user.email,
        user.status,
      );
    }

    return this.tokenGenerate(user.id, user.fullName, user.role, user.email);
  }

  async tokenGenerate(
    userId: number,
    fullName: string,
    role: string,
    email: string,
    status?: string,
  ) {
    const payload = {
      sub: userId,
      fullName,
      email,
      role,
    };
    const token: any = await this.jwt.signAsync(payload, {
      expiresIn: '1y',
      secret: 'brothers',
    });
    if (role === 'technician') {
      return {
        access_token: token,
        role,
        userId,
        status,
      };
    }
    return {
      access_token: token,
      role,
      userId,
    };
  }

  validateToken(token: string): any {
    try {
      const decodedToken = jwtEx.verify(token, 'brothers');
      console.log(decodedToken);
      if (decodedToken) {
        return decodedToken;
      }
    } catch (error) {
      console.error('JWT verification error:', error.message);
      return false;
    }
  }

  async changePassword(dto: any) {
    let user;
    console.log(dto);
    if (dto.role === 'customer') {
      user = await this.prisma.user.findUnique({
        where: {
          id: dto.id,
        },
      });
    } else if (dto.role === 'technician') {
      user = await this.prisma.technician.findUnique({
        where: {
          id: dto.id,
        },
      });
    } else if (dto.role === 'admin') {
      user = await this.prisma.admin.findUnique({
        where: {
          id: dto.id,
        },
      });
    }

    if (!user) {
      throw new NotFoundError('User With the given Id does not exist');
    }

    const pwMatches = await argon.verify(user.password, dto.password);

    if (!pwMatches) {
      throw new ForbiddenException('Old password is not correct!');
    }

    const hashed = await argon.hash(dto.newPassword);
    if (user.role === 'customer') {
      return await this.prisma.user.update({
        where: {
          id: dto.id,
        },
        data: { password: hashed },
        select: { password: true },
      });
    } else if (user.role === 'technician') {
      return await this.prisma.technician.update({
        where: {
          id: dto.id,
        },
        data: { password: hashed },
        select: { password: true },
      });
    } else if (user.role === 'admin') {
      return await this.prisma.admin.update({
        where: {
          id: dto.id,
        },
        data: { password: hashed },
        select: { password: true },
      });
    }
  }

  async deleteUser(id: number, role: any) {
    if (role === 'customer') {
      try {
        return await this.prisma.user.delete({
          where: {
            id: id,
          },
        });
      } catch (error) {
        throw new BadRequestException('Something Went wrong');
      }
    } else if (role === 'technician') {
      try {
        return await this.prisma.technician.delete({
          where: {
            id: id,
          },
        });
      } catch (error) {
        throw new BadRequestException('Something Went wrong');
      }
    } else if (role === 'admin') {
      throw new BadRequestException('Deleting Admin Account is not Possible!');
    }
  }
}
