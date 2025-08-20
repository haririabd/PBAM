from django import forms

class sijilKeahlianForm(forms.Form):
    name = forms.CharField(label="Nama Penuh", max_length=100)
    date = forms.CharField(label="Tarikh Pengesahan", max_length=100)
    noahli = forms.CharField(label="No Keahlian", max_length=10)