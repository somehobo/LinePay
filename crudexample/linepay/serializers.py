from rest_framework import serializers

from .models import *


class OfferSerializer(serializers.ModelSerializer):
    class Meta:
        model = Offer
        fields = ["amount", 'madeBy', "madeTo", "line"]

class LinepayUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = LinepayUser
        fields = ("email", "line", "offersTo", "offersFrom", "positionForSale", "isTemp")


class LineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Line
        fields = ("name", 'lineCode', 'users', 'business', "offers", "positions")

class BusinessSerializer(serializers.ModelSerializer):
    class Meta:
        model = Business
        fields = ("name", 'lines', 'businessOwner')

class BusinessOwnerSerializer(serializers.ModelSerializer):
    class Meta:
        model = BusinessOwner
        fields = ["name", "email"]

class DecrementLineSerializer(serializers.Serializer):
    lineID = serializers.IntegerField()
    position = serializers.IntegerField()

class JoinLineSerializer(serializers.Serializer):
    lineCode = serializers.CharField()
    userID = serializers.CharField(required=False,default='-1')

class CreateLineSerializer(serializers.Serializer):
    businessID = serializers.IntegerField()
    name = serializers.CharField()

class GetLineSerializer(serializers.Serializer):
    lineID = serializers.CharField()
    userID = serializers.CharField()

class UserSerializer(serializers.Serializer):
    userID = serializers.CharField()

class EmailSerializer(serializers.Serializer):
    email = serializers.CharField()
    userID = serializers.CharField()
