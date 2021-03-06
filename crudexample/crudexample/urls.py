"""crudexample URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path, include
from linepay import views
from rest_framework import routers

router = routers.DefaultRouter(trailing_slash=False)
router.register('offerDetails', views.OfferAPI)
router.register('businessOwnerDetails', views.BusinessOwnerAPI)
router.register('userDetails', views.UserAPI)
router.register('lineDetails', views.LineAPI)
router.register('businessDetails', views.BusinessAPI)

urlpatterns = [
    path('', include(router.urls)),
    path('CreateUser/', views.LinePayCreateUser),
    path('LinePayUser/<str:userName>', views.LinePayGetUser),
    path('CreateBusiness/', views.CreateBusiness),
    path('DecrementLine/', views.DecrementLine),
    path('JoinLine/',views.JoinLine),
    path('CreateLine/',views.CreateLine),
    path('CreateBusinessOwner/',views.CreateBusinessOwner),
    path('GetLineData/',views.GetLineData),
    path('TogglePositionForSale/', views.TogglePositionForSale),
    path('GetOffers/', views.GetOffers),
    path('LoginUser/', views.LoginLineUser),
    path('leaveLine/',views.LeaveLine),
    path('AcceptOffer/',views.AcceptOffer),
    path('CreateOffer/',views.CreateOffer),
    path('getBusinessOwnerLines/',views.getBusinessOwnerLines),
]
