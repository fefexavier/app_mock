import 'package:app_mock/core/colors';
import 'package:app_mock/features/pronto_atendimento/controller/atendimento_controller.dart';
import 'package:app_mock/features/pronto_atendimento/model/especialidade_model.dart';
import 'package:app_mock/features/pronto_atendimento/model/hospital_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class GerarGuiaPage extends StatefulWidget {
  const GerarGuiaPage({super.key});

  @override
  State<GerarGuiaPage> createState() => _GerarGuiaPageState();
}

class _GerarGuiaPageState extends State<GerarGuiaPage> {
  String? selectedHospital;
  String? selectedSpecialty;
  String searchQuery = '';

  final controller = Modular.get<AtendimentoController>();
  @override
  void initState() {
    controller.getHospitais();
    controller.getEspecialidades();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => HospitalSearchDialog(
                    hospitals: controller.hospitais,
                    onSelected: (hospital) {
                      setState(() {
                        selectedHospital = hospital;
                      });
                      Navigator.of(context).pop(); // Fecha o diálogo
                    },
                  ),
                );
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Escolha um Hospital',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  selectedHospital ?? 'Selecione um hospital',
                  style: TextStyle(
                    color:
                        selectedHospital == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          // Dropdown para escolher uma especialidade
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => SpecialtySearchDialog(
                    specialties: controller.especialidades,
                    onSelected: (specialty) {
                      setState(() {
                        selectedSpecialty = specialty;
                      });
                      Navigator.of(context).pop(); // Fecha o diálogo
                    },
                  ),
                );
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Escolha uma Especialidade',
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  selectedSpecialty ?? 'Selecione uma especialidade',
                  style: TextStyle(
                    color:
                        selectedSpecialty == null ? Colors.grey : Colors.black,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      lightColor.brandPrimary, // Cor do texto (branco)
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10), // Bordas arredondadas
                  ),
                  // Padding
                ),
                onPressed: () {
                  if (selectedHospital != null && selectedSpecialty != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Você selecionou: $selectedHospital e $selectedSpecialty'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Por favor, selecione um hospital e uma especialidade.'),
                      ),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Solicitar Guia de Autorização do plano',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ), // Tamanho do texto),
                  ),
                )),
          )
        ],
      ),
    );
  }
}

class HospitalSearchDialog extends StatefulWidget {
  final List<Hospital> hospitals;
  final Function(String) onSelected;

  const HospitalSearchDialog(
      {required this.hospitals, required this.onSelected, Key? key})
      : super(key: key);

  @override
  _HospitalSearchDialogState createState() => _HospitalSearchDialogState();
}

class _HospitalSearchDialogState extends State<HospitalSearchDialog> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredHospitals = widget.hospitals
        .where((hospital) =>
            hospital.nome.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return AlertDialog(
      title: Text(
        'Selecione o Hospital',
        style: TextStyle(color: lightColor.brandPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Pesquisar',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: lightColor.brandPrimary)),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 400,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: filteredHospitals.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredHospitals[index].nome),
                  onTap: () {
                    widget.onSelected(filteredHospitals[index].nome);
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Fechar',
            style: TextStyle(color: lightColor.brandSecondary),
          ),
        ),
      ],
    );
  }
}

class SpecialtySearchDialog extends StatefulWidget {
  final List<Especialidade> specialties;
  final Function(String) onSelected;

  const SpecialtySearchDialog(
      {required this.specialties, required this.onSelected, Key? key})
      : super(key: key);

  @override
  _SpecialtySearchDialogState createState() => _SpecialtySearchDialogState();
}

class _SpecialtySearchDialogState extends State<SpecialtySearchDialog> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSpecialties = widget.specialties
        .where((specialty) => specialty.nomeEspecialidade
            .toLowerCase()
            .contains(searchQuery.toLowerCase()))
        .toList();

    return AlertDialog(
      title: Text(
        'Selecione uma Especialidade',
        style: TextStyle(color: lightColor.brandPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Pesquisar',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: lightColor.brandPrimary)),
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
          ),
          SizedBox(height: 10),
          SizedBox(
            height: 400,
            width: double.maxFinite,
            child: ListView.builder(
              itemCount: filteredSpecialties.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredSpecialties[index].nomeEspecialidade),
                  onTap: () {
                    widget.onSelected(filteredSpecialties[index]
                        .nomeEspecialidade); // Chama a função de seleção
                  },
                );
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Fechar',
            style: TextStyle(color: lightColor.brandSecondary),
          ),
        ),
      ],
    );
  }
}
