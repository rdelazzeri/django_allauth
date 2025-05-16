
from django.urls import path
from . import views as v

urlpatterns = [
    path('', v.IndexView.as_view(), name='index'),
    path('dashboard/', v.DashboardView.as_view(), name='dashboard'),
]