from django.http import JsonResponse
from django.views import View

class HealthView(View):
    def get(self, request):
        return JsonResponse({
            'status': 'healthy',
            'service': 'insightric-upload-service'
        })

class ReadinessView(View):
    def get(self, request):
        return JsonResponse({
            'status': 'ready',
            'service': 'insightric-upload-service'
        })
