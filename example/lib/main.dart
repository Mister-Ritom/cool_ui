import 'package:flutter/material.dart';
import 'package:cool_ui/cool_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // User MUST instantiate CoolThemeExtension
    final coolTheme = CoolThemeExtension(
      primaryColor: const Color(0xFF6366F1), // Indigo
      secondaryColor: const Color(0xFFEC4899), // Pink
      themeMode: ThemeMode.system,
    );

    return MaterialApp(
      title: 'Cool UI Example',
      theme: ThemeData(
        useMaterial3: true,
        extensions: [coolTheme],
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        extensions: [coolTheme],
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const WidgetShowcase(),
    );
  }
}

class WidgetShowcase extends StatefulWidget {
  const WidgetShowcase({super.key});

  @override
  State<WidgetShowcase> createState() => _WidgetShowcaseState();
}

class _WidgetShowcaseState extends State<WidgetShowcase> {
  int _currentIndex = 0;
  int _tabIndex = 0;
  double _progressValue = 0.3;
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Animate progress for demo
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _progressValue = 0.7);
    }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CoolScaffold(
        appBar: AppBar(
        title: const Text('Cool UI Showcase'),
        backgroundColor: context.coolColors?.resolve(CoolColorToken.surface),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CoolColumn(
          children: [
            _buildSection('Layout Widgets', [
              _buildWidgetCard(
                'CoolLayout',
                CoolLayout(
                  padding: const EdgeInsets.all(16),
                  child: const Text('Layout with blur + tint surface'),
                ),
              ),
              _buildWidgetCard(
                'CoolRow',
                CoolRow(
                  children: [
                    _buildColorBox(Colors.red),
                    _buildColorBox(Colors.green),
                    _buildColorBox(Colors.blue),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolColumn',
                CoolColumn(
                  children: [
                    _buildColorBox(Colors.red),
                    _buildColorBox(Colors.green),
                    _buildColorBox(Colors.blue),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolGap',
                const CoolColumn(
                  children: [
                    Text('Item 1'),
                    CoolGap(size: 16),
                    Text('Item 2'),
                    CoolGap.horizontal(size: 20),
                    Text('Item 3'),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolColumn - With Divider',
                CoolColumn(
                  divider: const CoolDivider(),
                  children: [
                    const Text('Item 1'),
                    const Text('Item 2'),
                    const Text('Item 3'),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolDivider',
                const CoolColumn(
                  children: [Text('Above'), CoolDivider(), Text('Below')],
                ),
              ),
            ]),

            _buildSection('Buttons', [
              _buildWidgetCard(
                'CoolButton - Primary',
                CoolButton(
                  text: 'Primary Button',
                  onPressed: () => _showSnackBar('Primary pressed'),
                ),
              ),
              _buildWidgetCard(
                'CoolButton - Secondary',
                CoolButton(
                  text: 'Secondary Button',
                  variant: CoolButtonVariant.secondary,
                  onPressed: () => _showSnackBar('Secondary pressed'),
                ),
              ),
              _buildWidgetCard(
                'CoolButton - Outline',
                CoolButton(
                  text: 'Outline Button',
                  variant: CoolButtonVariant.outline,
                  onPressed: () => _showSnackBar('Outline pressed'),
                ),
              ),
              _buildWidgetCard(
                'CoolButton - Text',
                CoolButton(
                  text: 'Text Button',
                  variant: CoolButtonVariant.text,
                  onPressed: () => _showSnackBar('Text pressed'),
                ),
              ),
              _buildWidgetCard(
                'CoolButton - Loading',
                const CoolButton(text: 'Loading Button', isLoading: true),
              ),
              _buildWidgetCard(
                'CoolButton - Disabled',
                const CoolButton(text: 'Disabled Button', enabled: false),
              ),
              _buildWidgetCard(
                '🎯 State-Driven Animations (TEST THESE!)',
                CoolColumn(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            (context.coolColors?.resolve(
                                      CoolColorToken.infoContainer,
                                    ) ??
                                    Colors.blue)
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CoolColumn(
                        children: [
                          const Text(
                            'State → Animation Pipeline (FIXED)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
        ),
                          const SizedBox(height: 8),
                          const Text(
                            '✓ Press: Scale 0.96 + luminance shift',
                            style: TextStyle(fontSize: 11),
                          ),
                          const Text(
                            '✓ Release: ALWAYS returns to normal',
                            style: TextStyle(fontSize: 11),
                          ),
                          const Text(
                            '✓ Hover: Scale 1.02 + darken',
                            style: TextStyle(fontSize: 11),
                          ),
                          const Text(
                            '✓ Multi-channel animations',
                            style: TextStyle(fontSize: 11),
                          ),
                          const Text(
                            '✓ No stuck states',
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Try: Press and hold, then release',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CoolButton(
                      text: 'Primary (Filled) - Press & Hold!',
                      variant: CoolButtonVariant.primary,
                      onPressed: () => _showSnackBar('Primary released'),
                    ),
                    const SizedBox(height: 8),
                    CoolButton(
                      text: 'Secondary (Filled) - Press & Hold!',
                      variant: CoolButtonVariant.secondary,
                      onPressed: () => _showSnackBar('Secondary released'),
                    ),
                    const SizedBox(height: 8),
                    CoolButton(
                      text: 'Outline - Press & Hold!',
                      variant: CoolButtonVariant.outline,
                      onPressed: () => _showSnackBar('Outline released'),
                    ),
                    const SizedBox(height: 8),
                    CoolButton(
                      text: 'Text - Press & Hold!',
                      variant: CoolButtonVariant.text,
                      onPressed: () => _showSnackBar('Text released'),
                    ),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolButton - Sizes',
                CoolColumn(
                  children: [
                    CoolButton(
                      text: 'Small',
                      size: CoolButtonSize.small,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 8),
                    CoolButton(
                      text: 'Medium',
                      size: CoolButtonSize.medium,
                      onPressed: () {},
                    ),
                    const SizedBox(height: 8),
                    CoolButton(
                      text: 'Large',
                      size: CoolButtonSize.large,
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolIconButton',
                CoolRow(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CoolIconButton(
                      icon: Icons.favorite,
                      onPressed: () => _showSnackBar('Favorite pressed'),
                    ),
                    const SizedBox(width: 8),
                    CoolIconButton(
                      icon: Icons.share,
                      onPressed: () => _showSnackBar('Share pressed'),
                    ),
                    const SizedBox(width: 8),
                    CoolIconButton(
                      icon: Icons.settings,
                      onPressed: () => _showSnackBar('Settings pressed'),
                    ),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolFloatingButton',
                Center(
                  child: CoolFloatingButton(
                    icon: Icons.add,
                    onPressed: () => _showSnackBar('FAB pressed'),
                    tooltip: 'Add',
                  ),
                ),
              ),
            ]),

            _buildSection('Icons & Badges', [
              _buildWidgetCard(
                'CoolIcon',
                CoolRow(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CoolIcon(icon: Icons.star),
                    SizedBox(width: 16),
                    CoolIcon(icon: Icons.favorite, color: Colors.red),
                    SizedBox(width: 16),
                    CoolIcon(icon: Icons.thumb_up, color: Colors.blue),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolBadge',
                CoolRow(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications, size: 32),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: CoolBadge(
                            text: '5',
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 32),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.shopping_cart, size: 32),
                        Positioned(
                          right: -4,
                          top: -4,
                          child: CoolBadge(
                            text: '99+',
                            backgroundColor: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ]),

            _buildSection('Forms', [
              _buildWidgetCard(
                'CoolTextField',
                CoolTextField(
                  controller: _textController,
                  hintText: 'Enter text...',
                  labelText: 'Text Field',
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
              _buildWidgetCard(
                'CoolTextField - Error',
                CoolTextField(
                  hintText: 'Enter text...',
                  labelText: 'Text Field with Error',
                  errorText: 'This field is required',
                ),
              ),
            ]),

            _buildSection('Data Presentation', [
              _buildWidgetCard(
                'CoolCard',
                CoolCard(
                  onTap: () => _showSnackBar('Card tapped'),
                  child: const CoolColumn(
                    children: [
                      Text(
                        'Card Title',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('This is a card with blur + tint surface'),
                    ],
                  ),
                ),
              ),
              _buildWidgetCard(
                'CoolCard - Elevated (Notice the difference!)',
                CoolColumn(
                  children: [
                    CoolCard(
                      elevation: 0,
                      child: const CoolColumn(
                        children: [
                          Text(
                            'Normal Card (elevation: 0)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Simple surface, no blur or border'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CoolCard(
                      elevation: 2,
                      child: const CoolColumn(
                        children: [
                          Text(
                            'Elevated Card (elevation: 2)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Has blur, border, and higher contrast'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    CoolCard(
                      elevation: 4,
                      child: const CoolColumn(
                        children: [
                          Text(
                            'Highly Elevated Card (elevation: 4)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Strong blur and visual separation'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolDataTable',
                CoolDataTable(
                  columns: const [
                    CoolDataTableColumn(label: 'Name', width: 100),
                    CoolDataTableColumn(label: 'Age', width: 60),
                    CoolDataTableColumn(label: 'City', width: 100),
                  ],
                  rows: [
                    const CoolDataTableRow(
                      cells: [
                        Text('Alice'),
                        Text('25'),
                        Text('New York'),
                      ],
                    ),
                    const CoolDataTableRow(
                      cells: [
                        Text('Bob'),
                        Text('30'),
                        Text('London'),
                      ],
                      isSelected: true,
                    ),
                    const CoolDataTableRow(
                      cells: [
                        Text('Charlie'),
                        Text('28'),
                        Text('Paris'),
                      ],
                    ),
                  ],
                  onRowTap: (index) => _showSnackBar('Row $index tapped'),
                ),
              ),
            ]),

            _buildSection('Media', [
              _buildWidgetCard(
                'CoolAvatar - Initials',
                CoolRow(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CoolAvatar(text: 'JD', radius: 30),
                    const SizedBox(width: 16),
                    CoolAvatar(text: 'AB', radius: 30),
                    const SizedBox(width: 16),
                    CoolAvatar(icon: Icons.person, radius: 30),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolAvatar - Fallback from Name',
                CoolRow(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CoolAvatar(name: 'John Doe', radius: 30),
                    const SizedBox(width: 16),
                    CoolAvatar(name: 'Alice Brown', radius: 30),
                    const SizedBox(width: 16),
                    CoolAvatar(username: 'cooluser', radius: 30),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolAvatar - With Badge',
                Center(
                  child: CoolAvatar(
                    name: 'John Doe',
                    radius: 40,
                    badge: CoolBadge(text: '3', backgroundColor: Colors.green),
                  ),
                ),
              ),
            ]),

            _buildSection('Navigation', [
              _buildWidgetCard(
                'CoolTabs',
                CoolTabs(
                  tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
                  currentIndex: _tabIndex,
                  onTap: (index) => setState(() => _tabIndex = index),
                ),
              ),
            ]),

            _buildSection('Feedback', [
              _buildWidgetCard(
                'CoolProgressIndicator - Indeterminate',
                const CoolProgressIndicator(),
              ),
              _buildWidgetCard(
                'CoolProgressIndicator - Determinate',
                CoolColumn(
                  children: [
                    CoolProgressIndicator(value: _progressValue),
                    const SizedBox(height: 8),
                    Text(
                      'Progress: ${(_progressValue * 100).toStringAsFixed(0)}%',
                    ),
                    const SizedBox(height: 16),
                    CoolButton(
                      text: 'Reset Progress',
                      onPressed: () {
                        setState(() => _progressValue = 0.0);
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (mounted) {
                            setState(() => _progressValue = 0.3);
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolProgressIndicator - Linear',
                CoolColumn(
                  children: [
                    CoolProgressIndicator(
                      value: _progressValue,
                      isLinear: true,
                    ),
                    const SizedBox(height: 8),
                    CoolProgressIndicator(value: 0.5, isLinear: true),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolAlert - Info',
                const CoolAlert(
                  title: 'Information',
                  message: 'This is an info alert',
                  type: CoolAlertType.info,
                ),
        ),
              _buildWidgetCard(
                'CoolAlert - Success',
                const CoolAlert(
                  title: 'Success!',
                  message: 'Operation completed successfully',
                  type: CoolAlertType.success,
                ),
              ),
              _buildWidgetCard(
                'CoolAlert - Warning',
                const CoolAlert(
                  title: 'Warning',
                  message: 'Please be careful',
                  type: CoolAlertType.warning,
                ),
              ),
              _buildWidgetCard(
                'CoolAlert - Error',
                const CoolAlert(
                  title: 'Error',
                  message: 'Something went wrong',
                  type: CoolAlertType.error,
                ),
              ),
              _buildWidgetCard(
                'CoolSkeleton',
                const CoolColumn(
                  children: [
                    CoolSkeleton.text(width: 200),
                    SizedBox(height: 8),
                    CoolSkeleton.text(width: 150),
                    SizedBox(height: 12),
                    CoolRow(
                      children: [
                        CoolSkeleton.avatar(width: 40, height: 40),
                        SizedBox(width: 12),
                        Expanded(
                          child: CoolColumn(
                            children: [
                              CoolSkeleton.text(width: double.infinity),
                              SizedBox(height: 4),
                              CoolSkeleton.text(width: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    CoolSkeleton.card(width: double.infinity, height: 80),
                  ],
                ),
              ),
            ]),

            _buildSection('Overlays', [
              _buildWidgetCard(
                'CoolDialog',
                CoolButton(
                  text: 'Show Dialog',
                  onPressed: () {
                    CoolDialog.show(
                      context: context,
                      title: const Text(
                        'Dialog Title',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: const Text(
                        'This is a cool dialog with animations',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        CoolButton(
                          text: 'OK',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    );
                  },
                ),
              ),
              _buildWidgetCard(
                'CoolSheet - Bottom',
                CoolButton(
                  text: 'Show Bottom Sheet',
                  onPressed: () {
                    CoolSheet.show(
                      context: context,
                      title: 'Bottom Sheet',
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'This is a bottom sheet with blur backdrop',
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildWidgetCard(
                'CoolSheet - Top',
                CoolButton(
                  text: 'Show Top Sheet',
                  onPressed: () {
                    CoolSheet.show(
                      context: context,
                      direction: CoolSheetDirection.top,
                      title: 'Top Sheet',
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('This is a top sheet'),
                      ),
                    );
                  },
                ),
              ),
            ]),

            _buildSection('Collapsible & Sections', [
              _buildWidgetCard(
                'CoolCollapsible',
                CoolCollapsible(
                  isExpanded: true,
                  expandedChild: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Expanded content with smooth animation'),
                  ),
                ),
              ),
              _buildWidgetCard(
                'CoolSection',
                CoolSection(
                  title: 'Settings',
                  subtitle: 'Manage your preferences',
                  initialExpanded: false,
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Section content goes here'),
                  ),
                ),
              ),
              _buildWidgetCard(
                'CoolSection (Expanded)',
                CoolSection(
                  title: 'Notifications',
                  subtitle: '3 unread',
                  initialExpanded: true,
                  trailing: const Icon(Icons.notifications_active),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Notification settings and preferences'),
                  ),
                ),
              ),
            ]),
            _buildSection('Drag & Drop', [
              _buildWidgetCard(
                'CoolDraggable',
                CoolColumn(
                  children: List.generate(3, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: CoolDraggable(
                        key: ValueKey('draggable_$index'),
                        data: 'Item $index',
                        onDragStart: () => _showSnackBar('Drag started'),
                        onDragEnd: () => _showSnackBar('Drag ended'),
                        child: CoolCard(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                const Icon(Icons.drag_handle),
                                const SizedBox(width: 12),
                                Text('Draggable Item ${index + 1}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ]),
            _buildSection('Swipe Actions', [
              _buildWidgetCard(
                'CoolSwipeAction',
                CoolSwipeAction(
                  leftActions: [
                    CoolSwipeActionItem(
                      label: 'Edit',
                      icon: Icons.edit,
                      onTap: () => _showSnackBar('Edit tapped'),
                    ),
                  ],
                  rightActions: [
                    CoolSwipeActionItem(
                      label: 'Delete',
                      icon: Icons.delete,
                      onTap: () => _showSnackBar('Delete tapped'),
                    ),
                  ],
                  child: CoolCard(
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.message),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text('Swipe left or right for actions'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
            _buildSection('Menus', [
              _buildWidgetCard(
                'CoolMenuButton',
                CoolRow(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CoolMenuButton(
                      items: [
                        CoolMenuItem(
                          label: 'Edit',
                          icon: Icons.edit,
                          onTap: () => _showSnackBar('Edit tapped'),
                        ),
                        CoolMenuItem(
                          label: 'Share',
                          icon: Icons.share,
                          onTap: () => _showSnackBar('Share tapped'),
                        ),
                        CoolMenuItem(
                          label: 'Delete',
                          icon: Icons.delete,
                          isDestructive: true,
                          onTap: () => _showSnackBar('Delete tapped'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    CoolMenuButton(
                      icon: Icons.more_horiz,
                      items: [
                        const CoolMenuItem(
                          label: 'Option 1',
                          icon: Icons.settings,
                        ),
                        const CoolMenuItem(label: 'Option 2', icon: Icons.info),
                      ],
                    ),
                  ],
                ),
              ),
              _buildWidgetCard(
                'CoolPopupMenu',
                Center(
                  child: CoolPopupMenu(
                    items: [
                      CoolMenuItem(
                        label: 'Profile',
                        icon: Icons.person,
                        onTap: () => _showSnackBar('Profile tapped'),
                      ),
                      CoolMenuItem(
                        label: 'Settings',
                        icon: Icons.settings,
                        onTap: () => _showSnackBar('Settings tapped'),
                      ),
                      CoolMenuItem(
                        label: 'Logout',
                        icon: Icons.logout,
                        isDestructive: true,
                        onTap: () => _showSnackBar('Logout tapped'),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              context.coolColors?.resolve(
                                CoolColorToken.primary,
                              ) ??
                              Colors.blue,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text('Open Menu'),
                    ),
                  ),
                ),
              ),
            ]),

            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: CoolBottomNavigationBar(
        items: const [
          CoolBottomNavItem(icon: Icons.home, label: 'Home'),
          CoolBottomNavItem(icon: Icons.search, label: 'Search'),
          CoolBottomNavItem(
            icon: Icons.favorite,
            label: 'Favorites',
            badge: CoolBadge(text: '3'),
          ),
          CoolBottomNavItem(icon: Icons.person, label: 'Profile'),
        ],
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> widgets) {
    return CoolColumn(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        ...widgets,
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildWidgetCard(String title, Widget widget) {
    return CoolCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: CoolColumn(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          widget,
        ],
      ),
    );
  }

  Widget _buildColorBox(Color color) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
