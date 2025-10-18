import { Controller, Get } from '@nestjs/common';

@Controller()
export class HealthController {
  @Get('health')
  health() {
    return {
      status: 'healthy',
      service: 'insightric-auth-service',
    };
  }

  @Get('readiness')
  readiness() {
    return {
      status: 'ready',
      service: 'insightric-auth-service',
    };
  }
}
