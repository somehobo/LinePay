# Generated by Django 3.2.13 on 2022-05-13 19:48

from django.db import migrations, models
import django.db.models.deletion
import shortuuidfield.fields


class Migration(migrations.Migration):

    initial = True

    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='BusinessOwner',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('email', models.CharField(max_length=30, unique=True)),
            ],
        ),
        migrations.CreateModel(
            name='Line',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=20)),
                ('lineCode', shortuuidfield.fields.ShortUUIDField(blank=True, default='8Q2Z', editable=False, max_length=22)),
                ('positions', models.CharField(blank=True, default='', max_length=2000, null=True)),
                ('businessOwner', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='lines', to='linepay.businessowner')),
            ],
            options={
                'db_table': 'line',
            },
        ),
        migrations.CreateModel(
            name='LinepayUser',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('email', models.CharField(max_length=20)),
                ('positionForSale', models.BooleanField(default=False)),
                ('isTemp', models.BooleanField(default=False)),
                ('line', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='users', to='linepay.line')),
            ],
            options={
                'db_table': 'linepayUser',
            },
        ),
        migrations.CreateModel(
            name='Offer',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('amount', models.IntegerField()),
                ('line', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='offers', to='linepay.line')),
                ('madeBy', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='offersTo', to='linepay.linepayuser')),
                ('madeTo', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='offersFrom', to='linepay.linepayuser')),
            ],
        ),
        migrations.CreateModel(
            name='Business',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=20)),
                ('businessOwner', models.ForeignKey(null=True, on_delete=django.db.models.deletion.CASCADE, related_name='business', to='linepay.businessowner')),
            ],
            options={
                'db_table': 'business',
            },
        ),
    ]
