import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

@immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyWidget(),
        '/project': (context) => const MyWidget2(),
      },
    );
  }
}

@immutable
class MyWidget extends StatelessWidget {
  final List<String> platforms = const [
    'Android',
    'iOS',
    'Linux',
    'MacOS',
    'Windows',
  ];

  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed('/project');
        },
        child: const Icon(Icons.add),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 24.0,
            children: [
              // Row(
              //   children: [
              //     Expanded(
              //       child: Text(
              //         'Gerenciador de Projetos Flutter',
              //         style: Theme.of(context).textTheme.headlineSmall,
              //       ),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {},
              //       child: const Icon(Icons.settings),
              //     ),
              //   ],
              // ),
              Text('Lista de Projetos:',
                  style: Theme.of(context).textTheme.headlineSmall),
              // Card(
              //   child: ListTile(
              //     title: const Text('Você ainda não adicionou nenhum projeto.'),
              //   ),
              // ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 24.0,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceBright,
                        borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.1,
                        ),
                      ),
                      child: Icon(
                        Icons.mood_bad_outlined,
                        size: MediaQuery.of(context).size.width * 0.1,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text('Você ainda não adicionou nenhum projeto.',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
              Column(
                children: List.generate(
                  3,
                  (index) {
                    return Card(
                      clipBehavior: Clip.hardEdge,
                      child: ListTile(
                        title: Text('Projeto ${index + 1}'),
                        subtitle: const Text('Descrição do Projeto 1'),
                        leading: const CircleAvatar(
                          child: Icon(Icons.folder),
                        ),
                        trailing: PopupMenuButton<String>(
                          position: PopupMenuPosition.under,
                          onSelected: (value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ação escolhida: $value')),
                            );
                          },
                          itemBuilder: (BuildContext context) {
                            return [
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  spacing: 8.0,
                                  children: [
                                    Icon(Icons.edit_outlined),
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  spacing: 8.0,
                                  children: [
                                    Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    Text('Excluir'),
                                  ],
                                ),
                              ),
                            ];
                          },
                          icon: Icon(Icons.more_vert),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyWidget2 extends StatefulWidget {
  const MyWidget2({super.key});

  @override
  State<MyWidget2> createState() => _MyWidget2State();
}

class _MyWidget2State extends State<MyWidget2> {
  final List<String> platforms = const [
    'Android',
    'iOS',
    'Linux',
    'MacOS',
    'Windows',
  ];
  final List<String> models = const [
    'Aplicação',
    'Plugin',
    'Projeto vazio',
  ];
  final List<String> organizations = const [
    'com.example',
    'io.github',
  ];
  final TextEditingController _projectNameController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final FocusNode _organizationFocusNode = FocusNode();
  final FocusNode _modelFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Projeto'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            TextField(
              controller: _projectNameController,
              decoration: const InputDecoration(
                labelText: 'Nome do Projeto',
                border: OutlineInputBorder(),
              ),
            ),
            RawAutocomplete<String>(
              focusNode: _organizationFocusNode,
              textEditingController: _organizationController,
              optionsBuilder: (TextEditingValue textEditingValue) {
                // Retorna todas as opções se o campo estiver ativo,
                // ou filtra pelas opções com base no texto digitado.
                return organizations.where((option) => option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Você selecionou: $selection')),
                );
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Organização',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    elevation: 4.0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 200.0,
                        maxWidth: MediaQuery.of(context).size.width - 32,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final projectName = _projectNameController
                                  .text.isEmpty
                              ? ''
                              : '.${_projectNameController.text.replaceAll(" ", "").replaceAll("-", "").toLowerCase()}';
                          final option =
                              '${options.elementAt(index)}$projectName';

                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            RawAutocomplete<String>(
              focusNode: _modelFocusNode,
              textEditingController: _modelController,
              optionsBuilder: (TextEditingValue textEditingValue) {
                // Retorna todas as opções se o campo estiver ativo,
                // ou filtra pelas opções com base no texto digitado.
                return models.where((option) => option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase()));
              },
              onSelected: (String selection) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Você selecionou: $selection')),
                );
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Modelo',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    color: Theme.of(context).colorScheme.surfaceContainerLow,
                    elevation: 4.0,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 200.0,
                        maxWidth: MediaQuery.of(context).size.width - 32,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final option = options.elementAt(index);

                          return ListTile(
                            title: Text(option),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            Card(
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: () {},
                child: ListTile(
                  leading: Icon(
                    Icons.folder,
                    color: Theme.of(context).colorScheme.primaryFixed,
                  ),
                  title: Text('Escolher Diretório'),
                  subtitle:
                      Text('Selecione o diretório onde o projeto será criado.'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Plataformas:'),
                ),
                subtitle: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(
                    platforms.length,
                    (index) {
                      return ActionChip(
                        onPressed: () {},
                        avatar: Checkbox(
                          value: false,
                          onChanged: (_) {},
                        ),
                        backgroundColor: index % 2 == 0
                            ? Theme.of(context).colorScheme.surfaceContainerHigh
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHigh,
                        label: Text(platforms[index]),
                        labelStyle: TextStyle(
                          color: index % 2 == 0
                              ? Theme.of(context).colorScheme.onSurface
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            ListTile(
              leading: Checkbox(
                value: false,
                onChanged: (_) {},
              ),
              title: Text('Inicialização do repositório Git.'),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Endereço do repositório Git',
                border: OutlineInputBorder(),
              ),
            ),
            const Divider(),
            Row(
              spacing: 8.0,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.save),
                  label: Text('Criar Projeto'),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.delete),
                  label: Text('Limpar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.system,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: Colors.deepPurple,
//           brightness: Brightness.dark,
//         ),
//       ),
//       home: CommandInterface(),
//     );
//   }
// }

// class CommandInterface extends StatefulWidget {
//   const CommandInterface({super.key});

//   @override
//   State<CommandInterface> createState() => _CommandInterfaceState();
// }

// class _CommandInterfaceState extends State<CommandInterface> {
//   final TextEditingController _outputController = TextEditingController();
//   String _projectName = "";
//   String _projectPath = "";

//   Future<void> _runCommand(String command, List<String> args) async {
//     try {
//       final result = await Process.run(command, args, runInShell: true);
//       setState(() {
//         _outputController.text += '\n${result.stdout}';
//         if (result.stderr.isNotEmpty) {
//           _outputController.text += '\nError: ${result.stderr}';
//         }
//       });
//     } catch (e) {
//       setState(() {
//         _outputController.text += '\nFailed to execute command: $e';
//       });
//     }
//   }

//   void _createFlutterProject() {
//     if (_projectName.isNotEmpty && _projectPath.isNotEmpty) {
//       _runCommand('flutter', ['create', '$_projectPath/$_projectName']);
//     }
//   }

//   void _initializeGitRepo() {
//     if (_projectName.isNotEmpty && _projectPath.isNotEmpty) {
//       final projectPath = '$_projectPath/$_projectName';
//       _runCommand('git', ['init', projectPath]);
//     }
//   }

//   void _addPlatforms() {
//     if (_projectName.isNotEmpty && _projectPath.isNotEmpty) {
//       final projectPath = '$_projectPath/$_projectName';
//       _runCommand('flutter',
//           ['create', '.', '--platforms=android,ios', '-o', projectPath]);
//     }
//   }

//   // Função para abrir o seletor de diretórios
//   Future<void> _selectDirectory() async {
//     // Permite ao usuário escolher o diretório de destino
//     final String? directory = await FilePicker.platform.getDirectoryPath();
//     if (directory != null) {
//       setState(() {
//         _projectPath = directory;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Flutter Project Manager")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(labelText: "Project Name"),
//               onChanged: (value) {
//                 _projectName = value.trim();
//               },
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _selectDirectory,
//               child: Text("Select Project Location"),
//             ),
//             Text(
//               _projectPath.isEmpty
//                   ? "No directory selected"
//                   : "Selected Directory: $_projectPath",
//               style: TextStyle(
//                   color: _projectPath.isEmpty ? Colors.red : Colors.green),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: _createFlutterProject,
//               child: Text("Create Flutter Project"),
//             ),
//             ElevatedButton(
//               onPressed: _initializeGitRepo,
//               child: Text("Initialize Git Repository"),
//             ),
//             ElevatedButton(
//               onPressed: _addPlatforms,
//               child: Text("Add Android and iOS Platforms"),
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: TextField(
//                 controller: _outputController,
//                 maxLines: null,
//                 decoration: InputDecoration(
//                   labelText: "Command Output",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
