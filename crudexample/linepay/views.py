from linepay.models import *
from .serializers import *
from rest_framework import viewsets, status
from rest_framework.response import Response
from rest_framework.decorators import api_view
import json



# Create your views here.

class OfferAPI(viewsets.ModelViewSet):
    #permission_classes = [permissions.IsAuthenticated]
    queryset = Offer.objects.all()
    serializer_class = OfferSerializer

class BusinessOwnerAPI(viewsets.ModelViewSet):
    #permission_classes = [permissions.IsAuthenticated]
    queryset = BusinessOwner.objects.all()
    serializer_class = BusinessOwnerSerializer

class UserAPI(viewsets.ModelViewSet):
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

def takeOutOfLine(line, userID):
    if(line.positions != ""):
        positions = json.loads(line.positions)
        positions.remove(int(userID))
        user = LinepayUser.objects.get(id=userID)
        user.line = None
        user.save()
        line.positions = json.dumps(positions)
        line.save()


def getPosition(user):
    positions = json.loads(user.line.positions)
    print(positions)
    return positions.index(user.id) +1


@api_view(['POST'])
def LeaveLine(request):
    userSerializer = UserSerializer(data = request.data)
    if(userSerializer.is_valid()):
        user = LinepayUser.objects.get(id=userSerializer.data['userID'])
        takeOutOfLine(line=user.line, userID=user.id)
        #delete offers made to and from user before they leave
        Offer.objects.filter(madeBy=user).delete()
        Offer.objects.filter(madeTo=user).delete()
        return Response(status=status.HTTP_201_CREATED)
    return Response(userSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


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
        user = None
        if (not BusinessOwner.objects.filter(email=businessOwnerSerializer.data['email']).exists()):
            user = BusinessOwner(email=businessOwnerSerializer.data['email']).save()
        user = BusinessOwner.objects.get(email=businessOwnerSerializer.data['email'])
        data = businessOwnerSerializer.data
        data.update({"userID": str(user.id)})
        #this is because using the same response object on user side
        data.update({'lineID': -1})
        return Response(data, status=status.HTTP_201_CREATED)
    print(businessOwnerSerializer.errors)
    return Response(businessOwnerSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
def LinePayGetUser(request, userName):
        users = LinepayUser.objects.filter(name=userName)
        userSerializer = LinepayUserSerializer(users, many=True)
        return Response(userSerializer.data)

@api_view(['POST'])
def getBusinessOwnerLines(request):
    boIDSerializer = BusinessOwnerIDSerializer(data=request.data)
    if boIDSerializer.is_valid():
        god = {}
        data = {}
        lineIDs = {}
        lineCodes = {}
        if (BusinessOwner.objects.filter(id=boIDSerializer.data['boID']).exists):
            lines = Line.objects.filter(businessOwner=boIDSerializer.data['boID'])
            for line in lines:
                if (line.positions != ''):
                    data[line.name] = len(json.loads(line.positions))
                data[line.name] = 0
                lineIDs[line.name] = line.id
                lineCodes[line.name] = line.lineCode
            god.update({"lines": data})
            god.update({"lineIDs": lineIDs})
            god.update({"lineCodes": lineCodes})
        print(god)

        return Response(god, status=status.HTTP_201_CREATED)
    return Response(boIDSerializer.errors, status=status.HTTP_400_BAD_REQUEST)

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
        results = [[],[],[]]
        for offer in offers:
            results[0].append(offer.amount)
            results[1].append(getPosition(offer.madeBy))
            results[2].append(offer.id)

        # results.sort(key=lambda x:x[0])
        print(results)
        data = {'amounts' : results[0], 'positions':results[1], 'offerIDs': results[2]}
        return Response(data, status=status.HTTP_201_CREATED)
    return Response(userSerializer.errors, status=status.HTTP_400_BAD_REQUEST)



# decrement line json format
# {"lineID":1,"position":1}

@api_view(['POST'])
def DecrementLine(request):
    decrementLineSerializer = DecrementLineSerializer(data=request.data)
    if(decrementLineSerializer.is_valid()):
        lineID = decrementLineSerializer.data['lineID']
        line = Line.objects.get(id=lineID)
        position = decrementLineSerializer.data['position']
        positions = line.positions
        print(position)
        if(positions != ""):
            firstID = json.loads(positions)[position-1]
            takeOutOfLine(line, firstID)
        return Response(decrementLineSerializer.data, status=status.HTTP_201_CREATED)
    return Response(decrementLineSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


# {
#     "name": "",
#     "users": [],
#     "business": null
# }

@api_view(["POST"])
def CreateLine(request):
    createLineSerializer = CreateLineSerializer(data=request.data)
    if(createLineSerializer.is_valid()):
        if (not Line.objects.filter(name=createLineSerializer.data['name']).exists()):
            Line(name=createLineSerializer.data['name'], businessOwner = BusinessOwner.objects.get(id=createLineSerializer.data['businessOwner'])).save()

        #return Response({'lineID':str(line.id)}, status=status.HTTP_201_CREATED)
        return Response(status=status.HTTP_201_CREATED)
    return Response(createLineSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


# {"email":"test@mail.com", "userID":2}

@api_view(["POST"])
def LoginLineUser(request):
    emailSerializer = EmailSerializer(data=request.data)
    if(emailSerializer.is_valid()):
        userID = emailSerializer.data["userID"]
        email = emailSerializer.data["email"]
        oldUser = LinepayUser.objects.get(id=userID)
        user = None
        reuseTemp = False
        if(LinepayUser.objects.filter(email = email).exists()):
            user = LinepayUser.objects.get(email = email)
            user.line = oldUser.line
            user.save()
        else:
            reuseTemp = True
            oldUser.email = email
            oldUser.isTemp = False
            oldUser.save()
            user = oldUser
        if(user.line != None and not reuseTemp):
            #replace temp user in line if they are in one
            line = user.line
            positions = json.loads(line.positions)
            ind = positions.index(int(oldUser.id))
            positions.remove(int(oldUser.id))
            positions.insert(ind, user.id)
            line.positions = json.dumps(positions)
            line.save()
            oldUser.delete()
        data = {'userID': str(user.id), 'lineID':user.line.id}
        return Response(data, status=status.HTTP_201_CREATED)
    return Response(emailSerializer.errors, status=status.HTTP_400_BAD_REQUEST)


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
            user = LinepayUser(email = "nope@email.com", isTemp = True)
            user.save()
        else:
            user = LinepayUser.objects.get(id=userID)
        if(user.line != None):
            takeOutOfLine(user.line,userID)
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
                data['userID'] = str(user.id)
                data.update({"lineID": line.id})
                print(data)
                return Response(data, status=status.HTTP_201_CREATED)
    print(joinLineSerializer.errors)
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
        try:
            positionSend = list.index(int(user.id)) + 1
        except ValueError:
            positionSent = 0
        positionsForSale = LinepayUser.objects.filter(line=lineID,positionForSale=True)
        positionsForSaleSend = []
        if (positionsForSale):
            for position in positionsForSale:
                ind = int(position.id)
                if (position != user and ind < positionSend):
                    positionsForSaleSend.append(ind)

        lineNameSend = line.name
        data = getLineSerializer.data
        data.update(
        {'position':positionSend,
         'offersToMe':offersToMeSend,
         'offersFromMe':offersFromMeSend,
         'positionsForSale': positionsForSaleSend,
         'lineName':lineNameSend,
         'positionForSale':positionForSaleSend,
         'lineCode':line.lineCode,})
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


@api_view(['POST'])
def AcceptOffer(request):
    acceptOfferSerializer = AcceptOfferSerializer(data=request.data)
    if(acceptOfferSerializer.is_valid()):
        offer = Offer.objects.get(id=acceptOfferSerializer.data["offerID"])
        #swap positions
        positions = json.loads(offer.line.positions)
        ind1 = positions.index(offer.madeBy.id)
        ind2 = positions.index(offer.madeTo.id)
        temp = positions[ind2]
        positions[ind2] = positions[ind1]
        positions[ind1] = temp
        offer.line.positions = json.dumps(positions)
        offer.line.save()
        #get rid of all other offers for each user
        Offer.objects.filter(madeBy=offer.madeBy).delete()
        Offer.objects.filter(madeTo=offer.madeBy).delete()
        Offer.objects.filter(madeTo=offer.madeTo).delete()
        Offer.objects.filter(madeBy=offer.madeTo).delete()
        return Response(data={'accepted':True},status=status.HTTP_201_CREATED)
    return Response(status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
def CreateOffer(request):
    createOfferSerializer = CreateOfferSerializer(data = request.data)
    if(createOfferSerializer.is_valid()):
        userID = createOfferSerializer.data["userID"]
        user = LinepayUser.objects.get(id=userID)
        targetUserID = json.loads(user.line.positions)[int(createOfferSerializer.data["positions"])]
        targetUser = LinepayUser.objects.get(id=targetUserID)
        Offer(madeBy=user,
              madeTo=targetUser,
              amount=createOfferSerializer.data["amount"],
              line=user.line).save()
        return Response(data={'accepted':True},status=status.HTTP_201_CREATED)
    print(createOfferSerializer.errors)
    return Response(status=status.HTTP_400_BAD_REQUEST)

