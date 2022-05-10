from rest_framework import serializers

from .models import *


class OfferSerializer(serializers.ModelSerializer):
    class Meta:
        model = Offer
        fields = ["amount", 'madeBy', "madeTo", "line"]

class LinepayUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = LinepayUser
        fields = ("name", "email", "line", "offersTo", "offersFrom", "positionForSale")


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
        fields = ["name", "business"]

class DecrementLineSerializer(serializers.Serializer):
    lineID = serializers.IntegerField()
    position = serializers.IntegerField()

class JoinLineSerializer(serializers.Serializer):
    lineCode = serializers.CharField()
    userID = serializers.CharField()

class CreateLineSerializer(serializers.Serializer):
    businessID = serializers.IntegerField()
    name = serializers.CharField()

class GetLineSerializer(serializers.Serializer):
    lineID = serializers.CharField()
    userID = serializers.CharField()

class UserSerializer(serializers.Serializer):
    userID = serializers.CharField()
