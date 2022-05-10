from django.db import models
from django.contrib.auth.models import User
import shortuuid
from shortuuidfield import ShortUUIDField
from django.contrib.postgres.fields import ArrayField




# Create your models here.

class BusinessOwner(models.Model):
    email = models.CharField(max_length=20, unique=True)

class Business(models.Model):
    name = models.CharField(max_length=20)
    businessOwner = models.ForeignKey(BusinessOwner, on_delete=models.CASCADE, related_name='business', null = True)

    class Meta:
        db_table = "business"

class Line(models.Model):
    name = models.CharField(max_length=20)
    lineCode = ShortUUIDField(default=shortuuid.ShortUUID().random(length=4), editable=False)
    business = models.ForeignKey(Business, on_delete=models.CASCADE, related_name='lines', blank=True, null=True)
    positions = models.CharField(default = "", max_length=2000, null=True, blank=True)
    class Meta:
        db_table = "line"

class LinepayUser(models.Model):
    name = models.CharField(max_length=20)
    email = models.CharField(max_length=20)
    positionForSale = models.BooleanField(default=False)
    line = models.ForeignKey(Line, on_delete=models.CASCADE, related_name='users', blank=True, null=True)
    isTemp = models.BooleanField(default=False)
    class Meta:
        db_table = "linepayUser"

class Offer(models.Model):
    madeBy = models.ForeignKey(LinepayUser, on_delete=models.CASCADE, related_name='offersTo')
    madeTo = models.ForeignKey(LinepayUser, on_delete=models.CASCADE, related_name='offersFrom')
    amount = models.IntegerField()
    line = models.ForeignKey(Line, on_delete=models.CASCADE, related_name='offers')
