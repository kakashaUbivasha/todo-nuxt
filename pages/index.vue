<script setup>
import { ref, onMounted } from "vue";
import Todos from "~/components/home/Todos.vue";
import {generateRandomId} from "~/utils/generateId.js";

let todos = ref([]);

// Загрузка данных из localStorage только на клиенте
onMounted(() => {
  if (process.client) {
    const storedTodos = localStorage.getItem("todos");
    todos.value = storedTodos ? JSON.parse(storedTodos) : [
      {
        id: 1,
        title: "Моя первая заметка",
        items: [
          { task: "Купить молоко", isChecked: false },
          { task: "Позвонить другу", isChecked: true },
          { task: "Позвонить другу", isChecked: true },
          { task: "Позвонить другу", isChecked: true },
        ],
      },
      {
        id: 2,
        title: "Рабочие задачи",
        items: [
          { task: "Написать отчет", isChecked: false },
          { task: "Проверить почту", isChecked: false },
        ],
      },
    ];
  }
});
const deleteTodo = (id) => {
  const confirmDeletion = window.confirm("Вы уверены, что хотите удалить эту задачу?");
  if (confirmDeletion) {
    todos.value = todos.value.filter((item) => item.id !== id);
    saveTodosToLocalStorage();
  }
};
const saveTodosToLocalStorage = () => {
  if (process.client) {
    localStorage.setItem("todos", JSON.stringify(todos.value));
  }
};
const changeTodo = (id) => {

  if (process.client && !localStorage.getItem("todos")) {
    saveTodosToLocalStorage();
  }
  navigateTo(`/todo/${id}`);
};
const newTodo = () =>{
  if (process.client && !localStorage.getItem("todos")) {
    saveTodosToLocalStorage();
  }
  navigateTo(`todo/${generateRandomId()}`)
}
newTodo
watch(todos, saveTodosToLocalStorage, { deep: true });
</script>

<template>
  <div class="mb-20">
    <h1 class="text-5xl uppercase text-center my-20">Список todo</h1>
    <div v-for="todo in todos" class="">
      <todos
          :title="todo.title"
          :items ="todo.items"
          :id="todo.id"
          @delete-todo="deleteTodo(todo.id)"
          @change-todo="changeTodo(todo.id)"
      />
    </div>
    <div class="flex items-center justify-center">
      <button @click="newTodo" class="bg-cyan-600 hover:bg-cyan-700 text-white font-bold py-2 px-4 rounded">
        Добавить новый Todo
      </button>
    </div>
  </div>

</template>

<style scoped>

</style>