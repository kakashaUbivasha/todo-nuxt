<script setup>
import { ref } from "vue";

// Пропсы компонента
defineProps({
  todoId: Number,
});

const title = ref('');
const name = ref('');
const items = ref([]);
const isAdded = ref(false);
const isError = ref(false);
const isErrorName = ref(false);
const addItem = () => {
  if(name.value.trim() === ''){
    return isErrorName.value = true;
  }
  const itemObject = {
    id: Date.now(),
    task: name.value,
    isChecked: false,
  };
  items.value.push(itemObject);
  name.value = '';
  isErrorName.value = false;
};

const addTask = () => {
  if (title.value.trim() === '') {
    isError.value = true; // Показываем ошибку, если поле пустое
    return;
  }
  const confirmCancel = window.confirm("Вы уверены, что хотите создать новую заметку?");
  if(confirmCancel){
    const todoObject = {
      id: Date.now(),
      title: title.value,
      items: items.value,
    };
    const todos = JSON.parse(localStorage.getItem("todos")) || [];
    todos.push(todoObject);
    localStorage.setItem("todos", JSON.stringify(todos));
    title.value = '';
    items.value = [];
    isAdded.value = false;
    navigateTo('/')
  }

};
</script>

<template>
  <div class="max-w-3xl mx-auto p-4">
    <div class="space-y-4">
      <div class="flex flex-col">
        <label for="title" class="text-lg font-semibold text-gray-700">Введите название вашей заметки</label>
        <input
            id="title"
            v-model="title"
            class="mt-2 p-2 border w-52 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 md:w-full"
            placeholder="Название заметки"
            :style="isError ? 'border: 1px solid red;' : ''"
        />
        <span class="text-red-500" v-if="isError">Это поле обязательно для заполнения</span>
      </div>

      <button
          @click="isAdded = !isAdded"
          class="mt-4 bg-blue-500 text-white p-2 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400"
      >
        Добавить пункт
      </button>
    </div>

    <div v-if="isAdded" class="mt-4 gap-5 flex-col flex justify-between md:flex-row ">
      <div class="flex flex-col">
        <label for="name" class="text-lg font-semibold text-gray-700">Что вы хотите сделать?</label>
        <input
            id="name"
            v-model="name"
            class="mt-2 p-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500 w-52 md:w-96"
            placeholder="Задача"
        />
        <span class="text-red-500" v-if="isErrorName">Это поле обязательно для заполнения</span>
      </div>

      <button
          @click="addItem"
          class=" "
      >
        <span class="flex justify-center items-center pb-1.5 bg-green-500 text-white w-9 h-9 text-4xl rounded-lg hover:bg-green-600 focus:outline-none focus:ring-2 focus:ring-green-400">+</span>
      </button>
    </div>
  </div>

  <div class="mt-8">
    <h3 class="text-xl font-semibold text-gray-800 text-center">Список задач:</h3>
    <div v-if="!items.length" class="flex justify-center mt-5">
      <span class="text-2xl text-center text-gray-500">Список пуст...</span>

    </div>

      <ul class="space-y-2 mt-4 flex flex-col items-center">
        <li
            v-for="task in items"
            :key="task.id"
            class="flex items-center justify-center space-x-4 p-2 bg-gray-100 rounded-lg hover:bg-gray-200 w-60 md:w-96"
        >
          <input
              type="checkbox"
              :id="task.id"
              v-model="task.isChecked"
              class="h-5 w-5 text-blue-500 border-gray-300 rounded"
          />
          <label :for="task.id" class="text-gray-800 flex-grow">{{ task.task }}</label>
        </li>
      </ul>

  </div>
  <div class="flex justify-center">
    <button
        @click="addTask"
        class="mt-4 bg-blue-500 text-white p-2 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400"
    >
      Сохранить
    </button>
  </div>

</template>

<style scoped>
</style>
