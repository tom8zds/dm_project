import 'package:dmapicore/bloc/comic/local_comic/local_comic_cubit.dart';
import 'package:dmapicore/bloc/downloader/comic_downloader_cubit.dart';
import 'package:dmapicore/bloc/setting/app_config_cubit.dart';
import 'package:dmapicore/internal/app_constants.dart';
import 'package:dmapicore/views/setting/download_page.dart';
import 'package:dmapicore/views/setting/local_comic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer<AppConfigCubit, AppConfigState>(
      listener: (context, state) {},
      builder: (context, state) {
        final index = Colors.primaries.indexWhere(
            (element) => element.value == state.appConfig.colorSeed);
        final ScrollController scrollController =
            ScrollController(initialScrollOffset: index > 0 ? index * 96 : 0);
        return Scaffold(
          appBar: AppBar(
            title: const Text("设置"),
            centerTitle: true,
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ListTile(
                leading: SizedBox(
                  height: kToolbarHeight,
                  child: Icon(
                    Icons.brightness_6,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: const Text("主题模式"),
                subtitle: Text(state.appConfig.themeMode.getTitle()),
                trailing: TextButton(
                  child: Icon(state.appConfig.themeMode.getIcon()),
                  onPressed: () {
                    context.read<AppConfigCubit>().toggleThemeMode();
                  },
                ),
              ),
              ListTile(
                leading: SizedBox(
                  height: kToolbarHeight,
                  child: Icon(
                    Icons.color_lens_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: const Text("主题颜色"),
                subtitle: Text(
                  state.themeName,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 168,
                margin: const EdgeInsets.all(4),
                child: Row(
                  children: [
                    state.sysLightScheme == null
                        ? Container()
                        : ThemePresent(
                            title: "跟随系统",
                            lightScheme: state.sysLightScheme!,
                            darkScheme: state.sysDarkScheme!,
                            brightness: theme.brightness,
                            selected: state.appConfig.isSysColor,
                            onTap: () {
                              context
                                  .read<AppConfigCubit>()
                                  .toggleThemeColorMode(isSystem: true);
                            },
                          ),
                    state.sysLightScheme == null
                        ? Container()
                        : VerticalDivider(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    Expanded(
                      child: ListView.builder(
                        cacheExtent: MediaQuery.of(context).size.width,
                        controller: scrollController,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final color = Color(themeColors.elementAt(index));
                          final title = themeColorNames.elementAt(index);
                          return ThemePresent(
                            title: title,
                            lightScheme: ColorScheme.fromSeed(
                              seedColor: color,
                            ),
                            darkScheme: ColorScheme.fromSeed(
                                seedColor: color, brightness: Brightness.dark),
                            brightness: theme.brightness,
                            selected: (!state.appConfig.isSysColor) &&
                                color.value == state.appConfig.colorSeed,
                            onTap: () {
                              context
                                  .read<AppConfigCubit>()
                                  .changeColorSeed(color.value, title: title);
                            },
                          );
                        },
                        itemCount: themeColors.length,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                enabled: state.displayModeList.length > 1,
                leading: SizedBox(
                  height: kToolbarHeight,
                  child: Icon(
                    Icons.display_settings,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: const Text("显示模式"),
                trailing: DropdownButtonHideUnderline(
                  child: DropdownButton<DisplayMode>(
                    value: state.appConfig.displayMode,
                    items: state.displayModeList
                        .map(
                          (e) => DropdownMenuItem<DisplayMode>(
                            value: e,
                            child: Text(
                              e.refreshRate.toStringAsFixed(2),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (DisplayMode? value) {},
                  ),
                ),
              ),
              ListTile(
                leading: SizedBox(
                  height: kToolbarHeight,
                  child: Icon(
                    Icons.download_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: const Text("下载列队"),
                subtitle: Text(
                    "共 ${context.read<ComicDownloaderCubit>().missionBox.length} 本"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DownloadPage(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: SizedBox(
                  height: kToolbarHeight,
                  child: Icon(
                    Icons.collections_bookmark_outlined,
                    color: theme.colorScheme.primary,
                  ),
                ),
                title: const Text("本地漫画"),
                subtitle: Text(
                    "共 ${context.read<LocalComicCubit>().localComicBox.length} 本"),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const LocalComicPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class ThemePresent extends StatelessWidget {
  final String title;
  final ColorScheme lightScheme;
  final ColorScheme darkScheme;
  final Brightness brightness;
  final bool selected;
  final VoidCallback onTap;

  const ThemePresent({
    Key? key,
    required this.title,
    required this.lightScheme,
    required this.darkScheme,
    required this.selected,
    required this.onTap,
    required this.brightness,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = brightness == Brightness.light
        ? ThemeData.light().copyWith(
            useMaterial3: true,
            colorScheme: lightScheme,
          )
        : ThemeData.dark().copyWith(
            useMaterial3: true,
            colorScheme: darkScheme,
          );
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        Material(
          child: Ink(
            padding: const EdgeInsets.all(4),
            child: Ink(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color:
                    selected ? theme.colorScheme.primary : theme.disabledColor,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                splashColor: theme.colorScheme.surfaceVariant,
                onTap: () => onTap(),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: theme.colorScheme.background,
                  ),
                  width: 80,
                  height: 128,
                  child: Column(
                    children: [
                      Container(
                        height: 56,
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: theme.colorScheme.primaryContainer,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: 16,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(8),
                                ),
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Container(
                              height: 20,
                              width: 16,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.horizontal(
                                  right: Radius.circular(8),
                                ),
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 32,
                        alignment: Alignment.centerRight,
                        child: Container(
                          height: 24,
                          width: 24,
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: theme.colorScheme.tertiaryContainer,
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Ink(
                        height: 28,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(16),
                          ),
                          color: theme.colorScheme.surfaceVariant,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              height: 16,
                              width: 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Container(
                              height: 16,
                              width: 36,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                color: theme.colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
