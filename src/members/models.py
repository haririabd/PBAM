from django.db import models
from django import forms
from django.contrib.auth.models import User

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    icnumber = models.CharField(max_length=12, blank=True, null=False, help_text='Enter ic number', primary_key=True)
    notelefon = models.CharField(max_length=11, blank=True, null=True, help_text='Enter phone number')

    def __str__(self):
        return f'{self.user.username} Profile'

class ProfileForm(forms.ModelForm):
    class Meta:
        model = Profile
        fields = ['user', 'icnumber', 'notelefon']
        widgets = {
            'icnumber': forms.TextInput(attrs={
                'class': "form-control form-control-sm",
                'placeholder': "800101032122"
            }),
            'notelefon': forms.TextInput(attrs={
                'class': "form-control form-control-sm",
                'placeholder': "601234567890"
            })
        }