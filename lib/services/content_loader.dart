import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/course_models.dart';

class ContentLoader {
  static Future<List<Course>> loadCourses() async {
    return [
      await _loadDSACourse(),
      await _loadSystemDesignCourse(),
      await _loadGitCourse(),
    ];
  }

  static Future<Course> _loadDSACourse() async {
    final lessons = await _loadLessonsFromAssets('assets/courses/01.dsa/', [
      ('01.fundamental_cpp.md', 'Fundamental C++'),
      ('02.utilities.md', 'Utilities'),
      ('03.arr_&_strings.md', 'Arrays & Strings'),
      ('04.two_pointer_&_sliding_window.md', 'Two Pointer & Sliding Window'),
      ('05.hashing_&_map.md', 'Hashing & Map'),
      ('06.stack_queue_deque.md', 'Stack, Queue & Deque'),
      ('07.linked_list.md', 'Linked List'),
      ('08.sorting_&_binarySearch.md', 'Sorting & Binary Search'),
      ('09.recursion_&_backtracking.md', 'Recursion & Backtracking'),
      ('10.bit_manipulation.md', 'Bit Manipulation'),
      ('11.tree.md', 'Tree'),
      ('12.heap_&_PQ.md', 'Heap & Priority Queue'),
      ('13.greedy.md', 'Greedy'),
      ('14.graph-I.md', 'Graph I'),
      ('15.graph-II.md', 'Graph II'),
      ('16.graph-III.md', 'Graph III'),
      ('17.dynamic_programming.md', 'Dynamic Programming'),
      ('18.range_queries.md', 'Range Queries'),
      ('19.string-algo.md', 'String Algorithms'),
      ('20.geometry.md', 'Geometry'),
      ('21.competitive.md', 'Competitive Programming'),
      ('22.practice_&_system.md', 'Practice & System'),
    ]);

    return Course(
      title: 'DSA in C++',
      description: 'Complete Data Structures and Algorithms course',
      modules: [
        Module(
          title: 'DSA in C++',
          icon: '💻',
          lessons: lessons,
        ),
      ],
    );
  }

  static Future<Course> _loadSystemDesignCourse() async {
    final lessons = await _loadLessonsFromAssets('assets/courses/02.system_design/', [
      ('01.foundation_&_mindset.md', 'Foundation & Mindset'),
      ('02.requirement->api.md', 'Requirement to API'),
      ('03.back_of_the_envelope_estimation.md', 'Back of the Envelope Estimation'),
      ('04.networking_basics.md', 'Networking Basics'),
      ('05.load_balancing_&_gateway.md', 'Load Balancing & Gateway'),
      ('06.caching.md', 'Caching'),
      ('07.datastore.md', 'Datastore'),
      ('08.data_modeling_&_indexing.md', 'Data Modeling & Indexing'),
      ('09.replication,sharding,consistency.md', 'Replication, Sharding & Consistency'),
      ('10.distributed_system_primitives.md', 'Distributed System Primitives'),
      ('11.async_messaging_&_steams.md', 'Async Messaging & Streams'),
      ('12.search_&_analysis.md', 'Search & Analysis'),
      ('13.file,media&edge.md', 'File, Media & Edge'),
      ('14.observability.md', 'Observability'),
      ('15.reliability_&_resilience.md', 'Reliability & Resilience'),
      ('16.security_&_compliance.md', 'Security & Compliance'),
      ('17.security_&_architecture.md', 'Security & Architecture'),
      ('18.release_enginee_&_migration.md', 'Release Engineering & Migration'),
      ('19.dr,ha_&_multi-region.md', 'DR, HA & Multi-Region'),
      ('20.cost,capacity_&_finops.md', 'Cost, Capacity & FinOps'),
      ('21.platform_topics.md', 'Platform Topics'),
      ('22.classic_design_exercises.md', 'Classic Design Exercises'),
    ]);

    return Course(
      title: 'System Design',
      description: 'Comprehensive system design and architecture',
      modules: [
        Module(
          title: 'System Design',
          icon: '🏗️',
          lessons: lessons,
        ),
      ],
    );
  }

  static Future<Course> _loadGitCourse() async {
    final lessons = await _loadLessonsFromAssets('assets/courses/03.git/', [
      ('01.foundation.md', 'Foundation'),
      ('02.setting_up.md', 'Setting Up'),
      ('03.basic_work_flow.md', 'Basic Workflow'),
      ('04.branching_and_merging.md', 'Branching and Merging'),
      ('05.collaboration_with_github.md', 'Collaboration with GitHub'),
      ('06.intermediate_technique.md', 'Intermediate Techniques'),
      ('FAQ.md', 'FAQ'),
      ('git_cheat_sheet.md', 'Git Cheat Sheet'),
    ]);

    return Course(
      title: 'Git & Version Control',
      description: 'Master Git and version control',
      modules: [
        Module(
          title: 'Git & Version Control',
          icon: '🔧',
          lessons: lessons,
        ),
      ],
    );
  }

  static Future<List<Lesson>> _loadLessonsFromAssets(
    String basePath,
    List<(String, String)> files,
  ) async {
    List<Lesson> lessons = [];

    for (var (fileName, title) in files) {
      lessons.add(Lesson(
        title: title,
        fileName: fileName,
        path: '$basePath$fileName',
      ));
    }

    return lessons;
  }

  static Future<String> loadLessonContent(String path) async {
    return await rootBundle.loadString(path);
  }
}
