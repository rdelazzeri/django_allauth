from django.shortcuts import render
from django.views import View
from django.http import HttpResponse

class IndexView(View):
    def get(self, request):
        return render(request, 'core/index.html')
    
class DashboardView(View):
    def get(self, request):
        return render(request, 'core/dashboard.html')    

