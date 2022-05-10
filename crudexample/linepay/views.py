from django.shortcuts import render, redirect
from linepay.models import *
from .serializers import *
from rest_framework import viewsets, status, permissions
from rest_framework.response import Response
from rest_framework.decorators import api_view
import json



# Create your views here.

class OfferAPI(viewsets.ModelViewSet):
    #permission_classes = [permissions.IsAuthenticated]
    queryset = Offer.objects.all()
    serializer_class = OfferSerializer

class BusinessOwner(viewsets.ModelViewSet):
    #permission_classes = [permissions.IsAuthenticated]
    queryset = BusinessOwner.objects.all()
    serializer_class = BusinessOwnerSerializer

class User(viewsets.ModelViewSet):
    #permission_classes = [permissions.IsAuthenticated]
    queryset = LinepayUser.objects.all()
    serializer_class = LinepayUserSerializer

class LineAPI(viewsets.ModelViewSet):
    #permission_classes = [permissions.IsAuthenticated]
    queryset = Line.objects.all()
    serializer_class = LineSerializer

class BusinessAPI(viewsets.ModelViewSet):
    #permission_classes = [permissions.IsAuthenticated]
    queryset = Business.objects.all()
    serializer_class = BusinessSerializer

def takeOutOfLine(lineID, userID):
    line = Line.objects.get(id=lineID)
    positions = json.loads(line.positions)
    print(userID)
    print(positions)
    positions.remove(int(userID))
    print(positions)
    line.positions = json.dumps(positions)
    print(line.positions)
    line.save()


# notes: businessUsrId = 4, businessId = 5, line code= 4JSX, userID = 9, position=1
# 2nd userID = 10,

# create user json format
# {
#     "name": "",
#     "line": null,
#     "linePosition": null,
#     "offersTo": [],
#     "offersFrom": []
# }
@api_view(['POST'])
def LinePayCreateUser(request):
    if(request.method == 'POST'):
        userSerializer = LinepayUserSerializer(data=request.data)
        if(userSerializer.is_valid()):
            user = userSerializer.save()
            data = userSerializer.data
            data.update({"usr-ID": user.id})
            return Response(data, status=status.HTTP_201_CREATED)
        return Response(userSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


# {
#     "name": "",
#     "business": []
# }

@api_view(['POST'])
def CreateBusinessOwner(request):
    businessOwnerSerializer = BusinessOwnerSerializer(data=request.data)
    if(businessOwnerSerializer.is_valid()):
        user = businessOwnerSerializer.save()
        data = businessOwnerSerializer.data
        data.update({"userID": user.id})
        return Response(data, status=status.HTTP_201_CREATED)
    return Response(businessOwnerSerializer.errors, status=status.HTTP_400_BAD_REQUEST)



@api_view(['GET'])
def LinePayGetUser(request, userName):
        users = LinepayUser.objects.filter(name=userName)
        userSerializer = LinepayUserSerializer(users, many=True)
        return Response(userSerializer.data)


# create business json format
# {
#     "name": "",
#     "lines": [],
#     "businessOwner": null
# }

@api_view(['POST'])
def CreateBusiness(request):
    businessSerializer = BusinessSerializer(data=request.data)
    if(businessSerializer.is_valid()):
        business = businessSerializer.save()
        data = businessSerializer.data
        data.update({"business-ID": business.id})
        return Response(data, status=status.HTTP_201_CREATED)
    return Response(businessSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


# {"userID": userID}

@api_view(['POST'])
def GetOffers(request):
    userSerializer = UserSerializer(data = request.data)
    if(userSerializer.is_valid()):
        user = LinepayUser.objects.get(id=userSerializer.data['userID'])
        offers = Offer.objects.filter(line = user.line, madeTo = user.id)
        results = []
        for offer in offers:
            row = [offer.amount,offer.madeBy.id,offer.madeTo.id]
            results.append(row)
        results.sort(key=lambda x:x[0])
        print(results)
        data = {'offers' : results}
        return Response(data, status=status.HTTP_201_CREATED)
    return Response(userSerializer.errors, status=status.HTTP_400_BAD_REQUEST)



# decrement line json format
# {"lineID":1,"position":1}

@api_view(['POST'])
def DecrementLine(request):
    decrementLineSerializer = DecrementLineSerializer(data=request.data)
    if(decrementLineSerializer.is_valid()):
        lineID = decrementLineSerializer.data['lineID']
        position = decrementLineSerializer.data['position']
        takeOutOfLine(lineID, position)
        return Response(decrementLineSerializer.data, status=status.HTTP_201_CREATED)
    return Response(decrementLineSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


# {
#     "name": "",
#     "users": [],
#     "business": null
# }

@api_view(["POST"])
def CreateLine(request):
    lineSerializer = LineSerializer(data=request.data)
    if(lineSerializer.is_valid()):
        lineSerializer.save()
        return Response(lineSerializer.data, status=status.HTTP_201_CREATED)
    return Response(lineSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


# {"lineCode":"fpCg","userID":1}

@api_view(['POST'])
def JoinLine(request):
    joinLineSerializer = JoinLineSerializer(data = request.data)
    if(joinLineSerializer.is_valid()):
        lineCode = joinLineSerializer.data['lineCode']
        line = Line.objects.get(lineCode=lineCode)
        userID = joinLineSerializer.data['userID']
        user = None
        if(userID == "-1"):
            #create temp user
            user = LinepayUser(name="Temporary", email = "nope@email.com", isTemp = True)
            user.save()
        else:
            user = LinepayUser.objects.get(id=userID)
        if(user.line != None):
            takeOutOfLine(line.id,userID)
            line = Line.objects.get(lineCode=lineCode)

        if(line != None):
            if(user != None):
                user.line = line
                if(not line.positions):
                    initial = [int(user.id)]
                    line.positions = json.dumps(initial)
                else:
                    print(line.positions)
                    list = json.loads(line.positions)
                    list.append(int(user.id))
                    line.positions = json.dumps(list)
                    print(line.positions)
                line.save()
                user.save()
                data = joinLineSerializer.data
                data['userID'] = user.id
                data.update({"position": len(line.positions) + 1})
                data.update({"lineID": line.id})
                return Response(data, status=status.HTTP_201_CREATED)
    return Response(joinLineSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def GetLineData(request):
    getLineSerializer = GetLineSerializer(data = request.data)
    if(getLineSerializer.is_valid()):
        userID = getLineSerializer.data['userID']
        lineID = getLineSerializer.data['lineID']
        user = LinepayUser.objects.get(id=userID)
        line = Line.objects.get(id = lineID)
        # business = Business.objects.get(id = line.Business)
        positionForSaleSend = user.positionForSale
        offersToMeSend = Offer.objects.filter(line = lineID, madeTo = userID).count() or 0
        print(offersToMeSend)
        offersFromMeSend = Offer.objects.filter(line = lineID, madeBy = userID).count() or 0
        list = json.loads(line.positions)
        positionSend = list.index(int(user.id)) + 1
        positionsForSale = LinepayUser.objects.filter(line=lineID,positionForSale=True)
        positionsForSaleSend = []
        if (positionsForSale):
            for position in positionsForSale:
                if (position != user):
                    positionsForSaleSend.append(list.index(int(position.id)))

        lineNameSend = line.name
        data = getLineSerializer.data
        data.update(
        {'position':positionSend,
         'offersToMe':offersToMeSend,
         'offersFromMe':offersFromMeSend,
         'positionsForSale': positionsForSaleSend,
         'lineName':lineNameSend,
         'positionForSale':positionForSaleSend,
         'lineCode':line.lineCode})
        #todo: estimated wait time
        return Response(data, status=status.HTTP_201_CREATED)
    return Response(getLineSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def TogglePositionForSale(request):
    userSerializer = UserSerializer(data = request.data)
    if(userSerializer.is_valid()):
        user = LinepayUser.objects.get(id=userSerializer.data['userID'])
        user.positionForSale = not user.positionForSale
        user.save()
        return Response(status=status.HTTP_201_CREATED)
    return Response(status=status.HTTP_400_BAD_REQUEST)
